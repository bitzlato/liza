# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Проверяет сумму залоченную на счету и суммы залоченные в ордерах, списаниях и депозитах
#
class AccountLocksChecker
  def initialize(account)
    @account = account
  end

  def perform
    Account.transaction do
      @account.reload
      locked_in_ask_orders = @account.ask_orders.active.sum(:locked)
      locked_in_bid_orders = @account.bid_orders.active.sum(:locked)
      origin_locked_in_ask_orders = @account.ask_orders.active.sum(:origin_locked)
      origin_locked_in_bid_orders = @account.bid_orders.active.sum(:origin_locked)
      locked_in_withdraws = @account.locked_in_withdraws
      locked_in_deposits = @account.locked_in_deposits
      total_locked = locked_in_ask_orders + locked_in_bid_orders + locked_in_withdraws + locked_in_deposits
      {
        origin_locked_in_ask_orders: origin_locked_in_ask_orders,
        origin_locked_in_bid_orders: origin_locked_in_bid_orders,
        locked_in_ask_orders: locked_in_ask_orders,
        locked_in_bid_orders: locked_in_bid_orders,
        locked_in_withdraws: locked_in_withdraws,
        locked_in_deposits: locked_in_deposits,
        total_locked: total_locked,
        account_locked: @account.locked,
        locked_equal: total_locked == @account.locked
      }
    end
  end
end
