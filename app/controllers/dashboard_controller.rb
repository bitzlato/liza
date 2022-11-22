# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DashboardController < ResourcesController
  layout 'fluid'
  def index
    render locals: {
      bitzlato_balances: BitzlatoWallet.market_balances,
      system_balances: AddressBalancesQuery.new.peatio_wallet_balances,
      accountable_fee: AccountableFeeCalculator.new.call,
      adjustments: Adjustment.accepted.group(:currency_id, :category).sum(:amount),
      belomor_balances: BelomorBlockchain.all.map(&:balances).inject { |memo, el| memo.to_h.merge(el.to_h) { |_, x, y| x.to_d + y.to_d } }
    }
  end
end
