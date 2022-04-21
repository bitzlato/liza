# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  # {Expense} is a income statement operation
  class Expense < Operation
    scope :exclude_bots, ->(exclude = true) do
      if exclude
        bots_ids = [Member::DEEP_STONER_BOT_ID, Member::BARGAINER_BOT_ID]
        bots_uids = Member.where(id: bots_ids).pluck(:uid)

        joins(%Q{
          LEFT JOIN deposits ON deposits.id = expenses.reference_id AND expenses.reference_type = 'Deposit'
          LEFT JOIN withdraws ON withdraws.id = expenses.reference_id AND expenses.reference_type = 'Withdraw'
          LEFT JOIN member_transfers ON member_transfers.id = expenses.reference_id AND expenses.reference_type = 'MemberTransfer'
          LEFT JOIN adjustments ON adjustments.id = expenses.reference_id AND expenses.reference_type = 'Adjustment'
        })
          .where(%Q{
            (reference_type = 'Deposit' AND deposits.member_id NOT IN (:bots_ids)) OR
            (reference_type = 'Withdraw' AND withdraws.member_id NOT IN (:bots_ids)) OR
            (reference_type = 'MemberTransfer' AND member_transfers.member_id NOT IN (:bots_ids)) OR
            (reference_type = 'Adjustment' AND adjustments.receiving_account_number !~* :bots_uids)
            }, bots_ids: bots_ids, bots_uids: "(#{bots_uids.join('|')})")
      end
    end
  end
end
