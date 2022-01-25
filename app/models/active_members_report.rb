# frozen_string_literal: true

class ActiveMembersReport < Report
  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def q
      {
        g: [
          { withdraws_created_at_gt: form.time_from, withdraws_created_at_lteq: form.time_to },
          { deposits_at_gt: form.time_from, deposits_at_lteq: form.time_to },
          { orders_at_gt: form.time_from, orders_at_lteq: form.time_to }
        ]
      }
    end

    def records
      Member.ransack(q).result(distinct: true)
    end
  end
end
