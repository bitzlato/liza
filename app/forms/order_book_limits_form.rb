class OrderBookLimitsForm < TimeRangeForm
  attr_accessor :market_id, :min_order_amount, :min_trade_amount
end
