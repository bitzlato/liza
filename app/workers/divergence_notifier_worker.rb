# frozen_string_literal: true

require 'fileutils'

class DivergenceNotifierWorker
  include Sidekiq::Worker
  
  STATUS_FILE = Rails.root.join('./tmp/divergence_exists')

  sidekiq_options queue: :reports

  def perform
    return if current_status == saved_status
    if current_status
      SlackNotifier.notifications.ping(":warning: Обнаружены расхождения #{url}")
    else
      SlackNotifier.notifications.ping(":white_check_mark: Расхождения устранены #{url}")
    end
    save_status! current_status
  end

  private
  
  def current_status
    @current_status ||= find_current_status
  end
  
  def find_current_status
    app = ActionDispatch::Integration::Session.new(Rails.application)
    url = Rails.application.routes.url_helpers.url_for(controller: :dashboard, action: :index)
    authorization = if Rails.env.production?
                      credentials = Rails.application.credentials.dig(:http_basic_auth)
                      authorization = ActionController::HttpAuthentication::Basic.encode_credentials(credentials[:name], credentials[:password])
                    end
    app.process :get, url, params: {}, headers: { 'Authorization' => authorization }
    body = app.response.body
    body =~ /data-divergence="true"/
  end

  def save_status!(status)
    if status
      FileUtils.touch STATUS_FILE
    else
      FileUtils.rm STATUS_FILE
    end
  end

  def saved_status
    File.exits? STATUS_FILE
  end
end
