# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class MemberTradesReport < Report
  def self.form_class
    MemberRecordsForm
  end

  def results
    super.merge(
      records: reporter.records,
      member: form_object.member_id.present? ? Member.find(form_object.member_id) : nil
    )
  end

  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def records
      Trade.ransack(q).result.includes(:maker, :taker, :market, :taker_order, :maker_order)
    end

    def file
      @file ||= generate_file
    end

    private

    def generate_file
      validate!
      dump_records %i[created_at id market taker_type seller buyer amount price total]
    end

    def q
      { maker_id_or_taker_id_eq: form.member_id, created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end
  end
end
