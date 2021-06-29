# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# TODO: Complete )
#
class MemberHistoryReport < Report
  def self.form_class
    MemberRecordsForm
  end

  def results
    {
      records: records,
      member: form_object.member
    }
  end

  def perform_async
    update results: {}, status: :success, processed_at: Time.zone.now
  end

  private

  def q
    { member_id_eq: form_object.member_id, created_at_gt: form_object.time_from, created_at_lteq: form_object.time_to }
  end

  def records
    (Deposit.ransack(q).result + Withdraw.ransack(q).result).sort_by(&:created_at)
  end

  class Generator < BaseGenerator
    def perform
      {}
    end
  end
end
