# frozen_string_literal: true

class Account < ApplicationRecord
  extend Memoist

  belongs_to :currency, required: true
  belongs_to :member, required: true

  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

  def divergence
    estimated_amount - amount
  end

  def trades
    member.trades.where(market_id: currency.dependent_markets)
  end

  def sell_trades
    Trade.where(market_id: currency.dependent_markets).where('((taker_type = ? and taker_id = ?) or (taker_type=? and maker_id=?))', 'sell', member_id, 'buy', member_id)
  end

  def buy_trades
    Trade.where(market_id: currency.dependent_markets).where('((taker_type = ? and taker_id = ?) or (taker_type=? and maker_id=?))', 'buy', member_id, 'sell', member_id)
  end

  def total_paid
    buy_trades.where(market_id: currency.quote_markets).sum(:total)
  end

  def total_revenue
    sell_trades.where(market_id: currency.quote_markets).sum(:total)
  end

  def total_sell
    sell_trades.where(market_id: currency.base_markets).sum(:amount)
  end

  def total_buy
    buy_trades.where(market_id: currency.base_markets).sum(:amount)
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

  def trade_income
    total_buy - total_sell + total_revenue - total_paid
  end

  def total_deposit_amount
    deposits.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_deposit_amount

  def total_withdraw_amount
    withdraws.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_withdraw_amount

  def maker_fees_amount
    0
  end

  def taker_fees_amount
    Trade.where(taker_id: member_id)
    0
  end

  def estimated_amount
    total_deposit_amount - total_withdraw_amount + trade_income - maker_fees_amount - taker_fees_amount
  end
end
