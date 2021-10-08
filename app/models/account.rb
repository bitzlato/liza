# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Account < ApplicationRecord
  extend Memoist

  self.primary_keys = :currency_id, :member_id

  belongs_to :currency, required: true
  belongs_to :member, required: true

  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

  def divergence
    estimated_amount - amount
  end

  def trades
    member.trades.where(market_id: currency.dependent_markets.pluck(:symbol))
  end

  def sell_trades
    Trade.where(market_id: currency.dependent_markets.pluck(:symbol)).where('((taker_type = ? and taker_id = ?) or (taker_type=? and maker_id=?))', 'sell',
                                                                            member_id, 'buy', member_id)
  end

  def buy_trades
    Trade.where(market_id: currency.dependent_markets.pluck(:symbol)).where('((taker_type = ? and taker_id = ?) or (taker_type=? and maker_id=?))', 'buy',
                                                                            member_id, 'sell', member_id)
  end

  def total_paid
    buy_trades.where(market_id: currency.quote_markets.pluck(:symbol)).sum(:total)
  end

  def total_revenue
    sell_trades.where(market_id: currency.quote_markets.pluck(:symbol)).sum(:total)
  end

  def total_sell
    sell_trades.where(market_id: currency.base_markets.pluck(:symbol)).sum(:amount)
  end

  def total_buy
    buy_trades.where(market_id: currency.base_markets.pluck(:symbol)).sum(:amount)
  end

  def withdraws
    member.withdraws.where(currency_id: currency_id)
  end

  def deposits
    member.deposits.where(currency_id: currency_id)
  end

  def locked_in_withdraws
    member.withdraws.where(currency_id: currency_id, is_locked: true).sum(:sum)
  end

  def locked_in_deposits
    member.deposits.where(currency_id: currency_id, is_locked: true).sum(:amount)
  end

  def base_orders
    member.orders.where(market_id: Market.where(base_unit: currency_id).pluck(:symbol))
  end

  def bid_orders
    quote_orders.where(type: 'OrderBid')
  end

  def ask_orders
    base_orders.where(type: 'OrderAsk')
  end

  def quote_orders
    member.orders.where(market_id: Market.where(quote_unit: currency_id).pluck(:symbol))
  end

  def amount
    balance + locked
  end

  def trade_income
    total_buy - total_sell + total_revenue - total_paid
  end

  def total_deposit_amount
    deposits.success.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_deposit_amount

  def total_withdraw_amount
    withdraws.success.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_withdraw_amount

  def operations_revenues
    member.operations_revenues.where(currency_id: currency_id)
  end

  def trades_fee
    operations_revenues.sum(:credit)
  end

  def estimated_amount
    total_deposit_amount - total_withdraw_amount + trade_income - trades_fee
  end
end
