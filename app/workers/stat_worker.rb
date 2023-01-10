# frozen_string_literal: true
#
class StatWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform(args)
    period = args['period']

    StatsMailer.send(period, date: Time.yesterday).deliver_now!
  end
end
