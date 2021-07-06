# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Worker to maker async reports
#
class ReporterWorker
  include Sidekiq::Worker

  sidekiq_options queue: :reports

  def perform(report_id)
    Report.find(report_id).perform!
  end
end
