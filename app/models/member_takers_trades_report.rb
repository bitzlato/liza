# frozen_string_literal: true

class MemberTakersTradesReport < Report
  def self.form_class
    MemberTakersTradesForm
  end

  def results
    super.sort_by { |_k, v| v }.reverse.to_h
  end

  class Generator < BaseGenerator
    def perform
      records.group(:market_id).count
    end

    def q
      q = {}
      q[:market_id_eq] = form.market_id if form.market_id.present?
      q[:created_at_gt] = form.time_from if form.time_from.present?
      q[:created_at_lteq] = form.time_to if form.time_to.present?
      q[:taker_order_swap_order_id_not_null] = 1 if form.only_quick_exchange?
      q
    end

    def records
      Trade.user_taker_trades
           .ransack(q)
           .result
    end
  end
end
