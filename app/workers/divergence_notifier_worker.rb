# frozen_string_literal: true

require 'fileutils'

class DivergenceNotifierWorker
  include Sidekiq::Worker

  STATUS_FILE = Rails.root.join('./tmp/divergence_exists')

  sidekiq_options queue: :reports

  def perform
    messages = []

    if current_divergent_currencies.none?
      messages << ":white_check_mark: Все расхождения устранены"
    end

    current_divergent_currencies.each do |key, new_values|
      if new_values.sort != saved_divergent_currencies.fetch(key, []).sort
        messages << ":exclamation: выявлено новое расхождение: #{key.upcase}"
        messages += current_divergent_currencies[key].map { |msg| "* #{msg}" }
      end
    end

    saved_divergent_currencies.each do |key, old_values|
      if old_values.sort != current_divergent_currencies.fetch(key, []).sort
        messages << ":white_check_mark: устранено расхождение: #{key.upcase}"
        messages += saved_divergent_currencies[key].map { |msg| "* #{msg}" }
      end
    end

    return if messages.blank?

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
