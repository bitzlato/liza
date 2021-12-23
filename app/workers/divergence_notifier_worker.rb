# frozen_string_literal: true
#
class DivergenceNotifierWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform
    app = ActionDispatch::Integration::Session.new(Rails.application)
    url = Rails.application.routes.url_helpers.url_for(controller: :dashboard, action: :index)
    authorization = if Rails.env.production?
                      credentials = Rails.application.credentials.dig(:http_basic_auth)
                      authorization = ActionController::HttpAuthentication::Basic.encode_credentials(credentials[:name], credentials[:password])
                    end
    app.process :get, url, params: {}, headers: { 'Authorization' => authorization }
    body = app.response.body

    if body =~ /data-divergence="true"/
      SlackNotifier.notifications.ping("Обнаружены расхождения #{url}")
    end
  end

end
