# frozen_string_literal: true

require 'fileutils'

class DivergenceNotifierWorker
  include Sidekiq::Worker

  STATUS_FILE = Rails.root.join('./tmp/divergence_exists')

  sidekiq_options queue: :reports

  def perform
    return if current_divergent_currencies == saved_divergent_currencies

    new_divergencies = current_divergent_currencies - saved_divergent_currencies
    fixed_divergencies = saved_divergent_currencies - current_divergent_currencies

    messages = []
    if current_divergent_currencies.any?
      messages << ":warning: Текущие расхождения: #{current_divergent_currencies.join(', ')}"
    else
      messages << ":white_check_mark: Все расхождения устранены"
    end
    messages << ":exclamation: Новые расхождения: #{new_divergencies.join(', ')}" if new_divergencies.any?
    messages << ":white_check_mark: Устраненные расхождения: #{fixed_divergencies.join(', ')}" if fixed_divergencies.any?
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
    page.css('[data-divergence]').map do |item|
      item.values[0].split(/\s+/)[1] # currency
    end.uniq.sort
  end

  def save_divergent_currencies!(currencies)
    File.write(STATUS_FILE, currencies.join(','))
  end

  def saved_divergent_currencies
    if File.exist? STATUS_FILE
      File.read(STATUS_FILE).strip.split(',')
    else
      []
    end
  end

  def dashboard_url
    @dashboard_url ||= Rails.application.routes.url_helpers.url_for(controller: :dashboard, action: :index)
  end
end
