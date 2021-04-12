# frozen_string_literal: true

module Operations
  class RevenueDecorator < ApplicationDecorator
    delegate_all

    def self.table_columns
      %i[account created_at member currency reference credit]
    end

    def credit
      h.format_money object.credit, object.currency
    end

    def reference
      h.present_liability_reference object.reference
    end
  end
end
