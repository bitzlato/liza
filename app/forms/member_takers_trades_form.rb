# frozen_string_literal: true

class MemberTakersTradesForm < TimeRangeForm
  attr_accessor :market_id, :only_quick_exchange

  def only_quick_exchange?
    only_quick_exchange == '1'
  end
end
