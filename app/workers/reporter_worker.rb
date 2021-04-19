class ReporterWorker
  include Sidekiq::Worker

  def perform(report_id)
    Report.find(report_id).perform!
  end
end
