# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  # {Liability} is a balance sheet operation
  class Liability < Operation
    belongs_to :member

    scope :exclude_bots, ->(exclude) do
      where.not(member_id: [Member::DEEP_STONER_BOT_ID, Member::BARGAINER_BOT_ID]) if exclude
    end

    def self.ransackable_scopes(auth_object = nil)
      [:exclude_bots]
    end
  end
end
