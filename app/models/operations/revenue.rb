# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  # {Revenue} is a income statement operation
  class Revenue < Operation
    belongs_to :member
    belongs_to :trade, foreign_key: :reference_id

    scope :exclude_bots, ->(exclude = true) do
      where.not(member_id: [Member::DEEP_STONER_BOT_ID, Member::BARGAINER_BOT_ID]) if exclude
    end

    scope :accountable, -> { where.not(reference_type: 'Adjustment') }

    def self.ransackable_scopes(auth_object = nil)
      [:exclude_bots]
    end
  end
end
