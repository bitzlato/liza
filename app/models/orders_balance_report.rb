# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class OrdersBalanceReport < Report
  def self.form_class
    nil
  end

  class Generator < BaseGenerator
    def perform
      markets = {}
      currencies = {}
      orders.each do |row|
        market_id, bid, ask, volume, volume_price = row
        markets[market_id] ||= { volume: 0, volume_price: 0 }
        markets[market_id][:volume] += volume
        markets[market_id][:volume_price] += volume_price
        currencies[ask] ||= 0
        currencies[ask] += volume
        currencies[bid] ||= 0
        currencies[bid] += volume_price
      end
      {
        markets: markets,
        currencies: currencies
      }
    end

    private

    def orders
      Order
        .where(state: :wait)
        .group(:market_id, :bid, :ask)
        .pluck(:market_id, :bid, :ask, 'sum(volume)', Arel.sql('sum(volume*price)'))
    end
  end
end
