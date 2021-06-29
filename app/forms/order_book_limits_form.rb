# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrderBookLimitsForm < TimeRangeForm
  attr_accessor :market_id, :min_order_amount, :min_trade_amount
end
