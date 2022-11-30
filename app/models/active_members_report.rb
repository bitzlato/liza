# frozen_string_literal: true

class ActiveMembersReport < Report
  class Generator < BaseGenerator
    def perform
      { records_count: count }
    end

    def q
      { created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def count
      withdraws_member_ids = Withdraw.ransack(q).result.group(:member_id).count.keys
      deposits_member_ids = Deposit.ransack(q).result.group(:member_id).count.keys
      orders_member_ids  = Order.ransack(q).result.group(:member_id).count.keys

      (withdraws_member_ids + deposits_member_ids + orders_member_ids).uniq.size
    end
  end
end
