# frozen_string_literal: true

class ActiveMembersReport < Report
  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def q
      {
        operations_liabilities_created_at_gt: form.time_from,
        operations_liabilities_created_at_lteq: form.time_to
      }
    end

    def records
      Member.ransack(q).result
    end
  end
end
