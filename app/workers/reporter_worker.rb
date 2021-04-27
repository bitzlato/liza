class ReporterWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform(report_id)
    Report.find(report_id).perform!
  end
end
