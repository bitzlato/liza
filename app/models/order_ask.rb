# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OrderAsk < Order
  scope :matching_rule, -> { order(price: :asc, created_at: :asc) }

  class << self
    def get_depth(market_id)
      where(market_id: market_id, state: :wait)
        .where.not(ord_type: :market)
        .order(price: :asc)
        .group(:price)
        .sum(:volume)
        .to_a
    end
  end
  # @deprecated
  def hold_account
    member.get_account(ask)
  end

  def expect_account
    member.get_account(bid)
  end

  def avg_price
    return ::Trade::ZERO if funds_used.zero?

    market.round_price(funds_received / funds_used)
  end

  # @deprecated Please use {income/outcome_currency} in Order model
  def currency
    Currency.find(ask)
  end

  def income_currency
    bid_currency
  end

  def outcome_currency
    ask_currency
  end

  def compute_locked
    case ord_type
    when 'limit'
      volume
    when 'market'
      estimate_required_funds(OrderBid.get_depth(market_id)) { |_p, v| v }
    end
  end
end
