class MemberOrdersReport < Report
  def self.form_class
    MemberRecordsForm
  end

  def results
    super.merge(
      records: reporter.records,
      member: form_object.member_id.present? ? Member.find(form_object.member_id) : nil
    )
  end

  private

  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def records
      Order.ransack(q).result.includes(:member, :market, :ask_currency, :bid_currency)
    end

    def file
      @file ||= generate_file
    end

    private

    def generate_file
      validate!
      dump_records %i[id created_at member market type state ord_type price volume origin_volume origin_locked funds_received maker_fee taker_fee]
    end

    def q
      { member_id_eq: form.member_id, created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end
  end
end
