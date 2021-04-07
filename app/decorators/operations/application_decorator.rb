# frozen_string_literal: true

module Operations
  class ApplicationDecorator < ::ApplicationDecorator
    def self.table_columns
      %i[created_at account currency reference debit credit]
    end

    def account
      h.link_to object.account do
        object.account.description + ' [' + object.account.scope + ']'
      end
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
