class OrderBookReport < Report
  class Generator < BaseGenerator
    LIMIT = 200
    def perform
      {
        time: Time.zone.now,
        markets:
        Market.enabled.map do |market|
          {
            market: market.as_json,
            order_ask: build_orders(OrderAsk, market: market),
            order_bid: build_orders(OrderBid, market: market),
          }
        end
      }
    end

    private

    def build_orders(order_class, market: )
      order_class
        .where(state: :wait, ord_type: :limit, market: market)
        .includes(:member)
        .order('price desc')
        .limit(LIMIT).map { |order| order.as_json(methods: [:type], include: [:member]) }
    end
  end
end
