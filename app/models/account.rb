# frozen_string_literal: true

class Account < ApplicationRecord
  extend Memoist

  belongs_to :currency, required: true
  belongs_to :member, required: true

  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

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
    total_deposit_amount - total_withdraw_amount
  end
end
