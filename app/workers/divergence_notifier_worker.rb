# frozen_string_literal: true

require 'fileutils'

class DivergenceNotifierWorker
  include Sidekiq::Worker

  STATUS_FILE = Rails.root.join('./tmp/divergence_exists')

  DIV_LIMITS = {
    'btc'       => 0.00022,
    'eth'       => 0.0031,
    'usdt'      => 10,
    'ustc'      => 10,
    'bnb-bep20' => 0.024,
    'ht-hrc20'  => 1,
    'avax'      => 0.12,
    'trx'       => 152
  }


  sidekiq_options queue: :reports

  def perform
    new_divergents = current_divergent_currencies.each_with_object([]) do |(key, new_values), messages|
                       if new_values.sort != saved_divergent_currencies.fetch(key, []).sort
                         messages << ":exclamation: выявлено новое расхождение: #{key.upcase}"
                         current_divergent_currencies[key].each { |msg| messages << "* #{msg}" }
                       end
                     end

    fixed_divergents = saved_divergent_currencies.each_with_object([]) do |(key, old_values), messages|
                         if old_values.sort != current_divergent_currencies.fetch(key, []).sort
                           messages << ":white_check_mark: устранено расхождение: #{key.upcase}"
                           saved_divergent_currencies[key].map { |msg| messages << "* #{msg}" }
                         end
                       end

    return if new_divergents.blank? && fixed_divergents.blank?

    messages = []
    messages << ":white_check_mark: Все расхождения устранены" if current_divergent_currencies.none?
    messages += new_divergents
    messages += fixed_divergents
    messages << "#{dashboard_url}"

    SlackNotifier.notifications.ping(messages.join("\n"))

    save_divergent_currencies!(current_divergent_currencies)
  end

  private

  def current_divergent_currencies
    @current_divergent_currencies ||= find_divergent_currencies
  end

  def find_divergent_currencies
    app = ActionDispatch::Integration::Session.new(Rails.application)
    authorization = if Rails.env.production?
                      credentials = Rails.application.credentials.dig(:http_basic_auth)
                      authorization = ActionController::HttpAuthentication::Basic.encode_credentials(credentials[:name], credentials[:password])
                    end
    app.process :get, dashboard_url, params: {}, headers: { 'Authorization' => authorization }

    page = Nokogiri::HTML(app.response.body)
    headers = page.css('.thead-dark tr th div').map(&:text)
    data = {}

    page.css('tbody tr').each do |tr|
      tr.css('td').each.with_index do |td, i|
        item = td.css('[data-divergence]').first
        next unless item

        amount, currency = item.values[0].split(/\s+/)

        next if DIV_LIMITS[currency].present? && amount.to_d < DIV_LIMITS[currency]

        data[currency] ||= []
        data[currency] << "#{headers[i]}: #{amount} #{currency.upcase}"
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
end
