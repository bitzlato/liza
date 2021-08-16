# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class ApplicationDecorator < ::ApplicationDecorator
    def self.table_columns
      %i[id created_at account currency reference debit credit]
    end

    def account
      h.format_liability_account object.account
    end

    def credit
      h.format_money object.credit, object.currency
    end

    def debit
      h.format_money object.debit, object.currency
    end

    def reference
      h.present_liability_reference object.reference
    end
  end
end
