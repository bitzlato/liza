# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module AccountsHelper
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
  def account_table_head_column(column, currency, totals)
    content_tag :td, class: AccountDecorator.table_th_class(column) do
      case column.to_s
      when 'id'
        t('total')
      when 'total_deposit_amount'
        format_money(currency.total_completed_deposits, currency)
      when 'total_withdraw_amount'
        format_money(currency.total_completed_withdraws, currency)
      when 'estimated_amount'
        format_money(currency.estimated_amount, currency)
      when 'divergence'
        format_divergence(currency.estimated_amount - (totals[:total_balance] + totals[:total_locked]), currency)
      when 'amount'
        format_money(totals[:total_balance] + totals[:total_locked], currency)
      when 'balance'
        format_money(totals[:total_balance], currency)
      when 'locked'
        format_money(totals[:total_locked], currency)
      else
        if totals.key? column.to_sym
          format_money totals[column.to_sym], currency
        else
          middot
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity
end
