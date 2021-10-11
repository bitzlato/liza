# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# TODO: Add admin rubric for Account.
module Operations
  class Account < PeatioRecord
    SCOPES = %w[member platform].freeze

    MEMBER_TYPES = %w[liability].freeze
    PLATFORM_TYPES = %w[asset expense revenue].freeze
    TYPES = (MEMBER_TYPES + PLATFORM_TYPES).freeze

    has_many :assets, foreign_key: :code, primary_key: :code
    has_many :expenses, foreign_key: :code, primary_key: :code
    has_many :revenues, foreign_key: :code, primary_key: :code
    has_many :liabilities, foreign_key: :code, primary_key: :code

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

    def to_s
      description + ' [' + scope + ']'
    end

    def records_class
      ('Operations::' + records_name.singularize.camelcase).constantize
    end

    def records_name
      type.pluralize
    end

    def records
      send records_name
    end
  end
end
