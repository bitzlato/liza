class ReporterWorker
  include Sidekiq::Worker

  sidekiq_options lock: :until_and_while_executing,
    unique_across_queues: true,
    queue: :reports

  def perform(report_id)
    Report.find(report_id).perform!
  end
end
