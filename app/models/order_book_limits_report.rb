class OrderBookLimitsReport < Report
  def self.form_class
    OrderBookLimitsForm
  end

  class Generator < BaseGenerator
    LIMIT = 20

    def perform
      {
        market: Market.find_by(symbol: form.market_id).as_json,
        limit: LIMIT,
        sellers: sales_trades,
        buyers: buys_trades,
        orders: orders.map(&:as_json),
        top_orders: top_orders
      }
    end

    private

    def q
      { market_id_eq: form.market_id, created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def trades
      Trade.ransack(q).result
    end

    def sum(ar1, ar2)
      ar = ar1.dup
      ar2.each do |row|
        if ar[row.first].present?
          ar[row.first] +=row.second
        else
          ar[row.first] = row.second
        end
      end
      ar.to_a.sort_by { |a| -a.second }
    end

    def buys_trades
      sum(
        trades.where(taker_type: :sell).group(:maker_id).order('count_all desc').limit(LIMIT).count,
        trades.where(taker_type: :buy).group(:taker_id).order('count_all desc').limit(LIMIT).count
      )
    end

    def sales_trades
      sum(
        trades.where(taker_type: :sell).group(:taker_id).order('count_all desc').limit(LIMIT).count,
        trades.where(taker_type: :buy).group(:maker_id).order('count_all desc').limit(LIMIT).count
      )
    end

    def orders
      Order.ransack(q).result.group(:member_id).order('count_all desc').limit(LIMIT).count
    end

    def top_orders
      Currency.pluck(:id).each_with_object({}) do |currency_id, object|
        object[currency_id] = Order.where(ask: currency_id).group(:member_id).order('sum_volume desc').sum(:volume).to_a
      end
    end
  end
end
