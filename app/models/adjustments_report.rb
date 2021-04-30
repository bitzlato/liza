class AdjustmentsReport < Report
  def results
    super.merge(
      records: reporter.records,
    )
  end

  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def records
      Adjustment.ransack(q).result.includes(:currency, :creator, :validator, :asset_account)
    end

    def file
      @file ||= generate_file
    end

    private

    def generate_file
      validate!
      dump_records Adjustment.attribute_names
    end

    def q
      { created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end
  end
end
