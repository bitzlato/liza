# frozen_string_literal: true

class Account < ApplicationRecord
  extend Memoist

  belongs_to :currency, required: true
  belongs_to :member, required: true

  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

  def trades
    member.trades.where(market_id: currency.dependent_markets)
  end

  def sell_trades
    trades.joins(:market).where(markets: { quote_unit: currency_id } )
  end

  def buy_trades
    trades.joins(:market).where(markets: { base_unit: currency_id } )
  end

  def total_sell
    sell_trades.sum(:total)
  end

  def total_buy
    buy_trades.sum(:total)
  end

  def withdraws
    member.withdraws.where(currency_id: currency_id)
  end

  def deposits
    member.deposits.where(currency_id: currency_id)
  end

  def base_orders
    member.orders.where(market_id: Market.where(base_unit: currency_id))
  end

  def quote_orders
    member.orders.where(market_id: Market.where(quote_unit: currency_id))
  end

  def amount
    balance + locked
  end

  def total_deposit_amount
    deposits.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_deposit_amount

  def total_withdraw_amount
    withdraws.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_withdraw_amount

  def estimated_amount
    total_deposit_amount - total_withdraw_amount + total_sell - total_buy
  end
end
