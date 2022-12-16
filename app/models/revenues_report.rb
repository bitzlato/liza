# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RevenuesReport < Report
  class Generator < BaseGenerator
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def perform
      currency_fees = {}
      markets = {}
      trades.each do |g|
        market_id, amount, volume = g
        markets[market_id] ||= {}
        markets[market_id][:base_turnover] = amount
        markets[market_id][:quote_turnover] = volume
      end
      revenues_scope('member_id = maker_id').each_pair do |keys, amount|
        market_id, currency = keys
        markets[market_id] ||= {}
        markets[market_id][currency] = amount
        currency_fees[currency] ||= 0
        currency_fees[currency] += amount
      end
      revenues_scope('member_id = taker_id and taker_id <> maker_id').each_pair do |keys, amount|
        market_id, currency = keys
        markets[market_id] ||= {}
        markets[market_id][currency] = amount
        currency_fees[currency] ||= 0
        currency_fees[currency] += amount
      end

      markets = Market.ordered
                      .where(symbol: markets.keys)
                      .each_with_object({}) { |m, a| a[m.symbol] = m.as_json }
                      .merge(markets)

      { records_count: markets.size + currency_fees.count, markets: markets, currency_fees: currency_fees }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    def q
      { reference_type_eq: 'Trade', created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def trades
      Trade.group(:market_id).pluck('market_id', 'sum(amount)', Arel.sql('sum(amount*price)'))
    end

    def revenues_scope(where)
      Operations::Revenue.ransack(q).result.joins(:trade).where(where).group(:market_id, :currency_id).sum(:credit)
    end
  end
end
