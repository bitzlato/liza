# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class AccountDecorator < ApplicationDecorator
    delegate_all

    def self.table_columns
      %i[code scope type kind description currency_type assets revenues expenses liabilities]
    end

    def assets
      present_operations :assets
    end

    def revenues
      present_operations :revenues
    end

    def expenses
      present_operations :expenses
    end

    def liabilities
      present_operations :liabilities
    end

    private

    # rubocop:disable Metrics/AbcSize
    def present_operations(association)
      operations = object.send association
      grouped_operations = operations.group(:currency_id).pluck(:currency_id, 'sum(credit), sum(debit)')

      grouped_operations.map do |o|
        currency_id, credit, debit = o
        currency = Currency.find(currency_id)
        h.link_to(h.url_for([:operations, association, { q: { currency_id_eq: currency_id, account_id_eq: object.id } }])) do
          (h.money_precission(credit, currency.precision) + ' / ' + h.money_precission(-debit, currency.precision) + ' ' + h.format_currency(currency)).html_safe
        end
      end.join(', ').html_safe
    end
    # rubocop:enable Metrics/AbcSize
  end
end
