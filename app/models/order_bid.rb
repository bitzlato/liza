# encoding: UTF-8
# frozen_string_literal: true

class OrderBid < Order
  LOCKING_BUFFER_FACTOR = '1.1'.to_d
  scope :matching_rule, -> { order(price: :desc, created_at: :asc) }

  class << self
    def get_depth(market_id)
      where(market_id: market_id, state: :wait)
        .where.not(ord_type: :market)
        .order(price: :desc)
        .group(:price)
        .sum(:volume)
        .to_a
    end
  end
  # @deprecated
  def hold_account
    member.get_account(bid)
  end

  def expect_account
    member.get_account(ask)
  end

  def avg_price
    return ::Trade::ZERO if funds_received.zero?
    market.round_price(funds_used / funds_received)
  end

  # @deprecated Please use {income/outcome_currency} in Order model
  def currency
    Currency.find(bid)
  end

  def income_currency
    ask_currency
  end

  def outcome_currency
    bid_currency
  end

  def compute_locked
    case ord_type
    when 'limit'
      price*volume
    when 'market'
      funds = estimate_required_funds(OrderAsk.get_depth(market_id)) {|p, v| p*v }
      # Maximum funds precision defined in Market::FUNDS_PRECISION.
      funds.round(Market::FUNDS_PRECISION, BigDecimal::ROUND_UP)
    end
  end
end
