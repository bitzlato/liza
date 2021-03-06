# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DashboardController < ResourcesController
  layout 'fluid'
  def index
    render locals: {
      bitzlato_balances: BitzlatoWallet.market_balances,
      system_balances: AddressBalancesQuery.new.service_balances,
      accountable_fee: AccountableFeeCalculator.new.call,
      adjustments: Adjustment.accepted.group(:currency_id, :category).sum(:amount)
    }
  end
end
