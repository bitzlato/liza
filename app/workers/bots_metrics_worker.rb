class BotsMetricsWorker
  include Sidekiq::Worker

  def perform
    timestamp = Time.current
    Member.bots_total_balances.map do |currency_id, amount|
      record = { amount: amount, currency_id: currency_id, timestamp: timestamp }

      BotsMetrics.write(record)
    end
  end
end
