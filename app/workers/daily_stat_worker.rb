# frozen_string_literal: true
#
class DailyStatWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform
    StatsMailer.daily(Date.yesterday).deliver_now!
  end
end
