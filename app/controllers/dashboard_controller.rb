# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DashboardController < ResourcesController
  layout 'fluid'
  def index
    render locals: {
      system_balances: Wallet.all.each_with_object({}) { |w, a| w.available_balances.each_pair { |c, b| a[c] ||= 0.0; a[c] += b.to_d } }, # rubocop:disable Style/Semicolon
      accountable_fee: Transaction.accountable_fee.group(:fee_currency_id).sum(:fee),
      adjustments: Adjustment.accepted.group(:currency_id, :category).sum(:amount)
    }
  end
end
