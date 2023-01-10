# frozen_string_literal: true

require 'fileutils'

class DivergenceNotifierWorker
  include Sidekiq::Worker

  STATUS_FILE = Rails.root.join('./tmp/divergence_exists')

  DIV_LIMITS = {
    'btc' => 0.001,
    'eth' => 0.0031,
    'usdt' => 10,
    'ustc' => 10,
    'bnb-bep20' => 0.024,
    'ht-hrc20' => 1,
    'avax' => 0.12,
    'trx' => 152
  }.freeze

  RETRY_PAUSE = 45

  sidekiq_options queue: :reports

  def perform
    messages = divergent_messages
    if messages.present?
      sleep RETRY_PAUSE
      messages = divergent_messages
    end
    return if messages.blank?

    messages << ':white_check_mark: Все расхождения устранены' if current_divergent_currencies.none?
    messages << dashboard_url.to_s
    messages.prepend "*Информация о расхождениях*\n"

    SlackNotifier.notifications.ping(messages.join("\n"))

    save_divergent_currencies!(current_divergent_currencies)
  end

  private

  def divergent_messages
    amounts = current_divergent_currencies.deep_transform_values { |v| { 'new_amount' => v } }.deep_merge(
      saved_divergent_currencies.deep_transform_values { |v| { 'old_amount' => v } }
    )
    amounts.map do |currency, columns|
      columns.map  do |column, data|
        new_amount = data['new_amount']
        old_amount = data['old_amount']

        if old_amount.nil? && new_amount.present?
          "\t :exclamation: *#{column}*: Новое расхождение *#{new_amount} #{currency.upcase}*\n"
        elsif old_amount.present? && new_amount.present?
          if old_amount.to_d.abs < new_amount.abs
            "\t :chart_with_upwards_trend: *#{column}*: Расхождение увеличилось ~#{old_amount}~ *#{new_amount} #{currency.upcase}*\n"
          elsif old_amount.to_d.abs > new_amount.abs
            "\t :chart_with_downwards_trend: *#{column}*: Расхождение уменьшилось ~#{old_amount}~ *#{new_amount} #{currency.upcase}*\n"
          end
        elsif old_amount.present? && new_amount.nil?
          "\t :white_check_mark: *#{column}* Расхождение устранено:\n"
        end
      end.then do |messages|
        "*#{currency.upcase}:*\n#{messages.join}" unless messages.compact.blank?
      end
    end.select(&:present?)
  end

  def current_divergent_currencies
    @current_divergent_currencies ||= find_divergent_currencies
  end

  def find_divergent_currencies
    page = Nokogiri::HTML(fetch_dashboard_html)
    headers = page.css('.thead-dark tr th div').map(&:text)
    data = {}

    page.css('tbody tr').each do |tr|
      tr.css('td').each.with_index do |td, i|
        item = td.css('[data-divergence]').first
        next unless item

        amount, currency = item.values[0].split(/\s+/)

        next if DIV_LIMITS[currency].present? && amount.to_d.abs < DIV_LIMITS[currency]

        data[currency] ||= {}
        data[currency][headers[i]] = amount.to_d
      end
    end

    data
  end

  def save_divergent_currencies!(currencies)
    File.write(STATUS_FILE, currencies.to_json)
  end

  def saved_divergent_currencies
    if File.exist? STATUS_FILE
      JSON.parse(File.read(STATUS_FILE).strip.to_s)
    else
      {}
    end
  end

  def dashboard_url
    @dashboard_url ||= Rails.application.routes.url_helpers.url_for(controller: :dashboard, action: :index)
  end

  def fetch_dashboard_html
    DashboardController.render :index, locals: {
      bitzlato_balances: BitzlatoWallet.market_balances,
      system_balances: AddressBalancesQuery.new.peatio_wallet_balances,
      accountable_fee: AccountableFeeCalculator.new.call,
      adjustments: Adjustment.accepted.group(:currency_id, :category).sum(:amount),
      belomor_balances: BelomorBlockchain.all.map(&:balances).inject { |memo, el| memo.to_h.merge(el.to_h) { |_, x, y| x.to_d + y.to_d } }
    }
  end
end
