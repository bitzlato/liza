# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class MemberWdReport < Report
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
      {
        records_count: deposits.count + withdraws.count
      }
    end

    # TODO: Use batch loading
    def records
      (deposits + withdraws).sort_by { |r| -r.created_at.to_i }
    end

    private

    def generate_file
      validate!
      dump_records %i[id created_at type amount currency]
    end

    def withdraws
      Withdraw.ransack(q).result
    end

    def deposits
      Deposit.ransack(q).result
    end

    def q
      { member_id_eq: form.member_id, created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end
  end
end
