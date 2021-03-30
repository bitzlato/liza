# frozen_string_literal: true

# TODO: Add admin rubric for Account.
module Operations
  class Account < ApplicationRecord
    SCOPES = %w[member platform].freeze

    MEMBER_TYPES = %w[liability].freeze
    PLATFORM_TYPES = %w[asset expense revenue].freeze
    TYPES = (MEMBER_TYPES + PLATFORM_TYPES).freeze

    def self.table_name_prefix
      'operations_'
    end

    # Type column reserved for STI.
    self.inheritance_column = nil

    # Allows dynamically check scopes.
    #   scope.platform?
    def scope
      super&.inquiry
    end

    # Allows dynamically check kinds.
    #   kind.main?
    def kind
      super&.inquiry
    end
  end
end
