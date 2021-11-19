# frozen_string_literal: true
#
class DivergenceNotifierWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform
    app = ActionDispatch::Integration::Session.new(Rails.application)
    url = Rails.application.routes.url_helpers.url_for(controller: :dashboard, action: :index)
    app.get(url)
    body = app.response.body

    if body !~ /data=divergence="true"/
      SlackNotifier.notifications.ping("Обнаружены расхождения #{url}")
    end
  end

end
