# frozen_string_literal: true

class Trade < ApplicationRecord
  # == Constants ============================================================

  extend Enumerize
  ZERO = '0.0'.to_d

  # == Relationships ========================================================

  belongs_to :market, required: true
  belongs_to :maker_order, class_name: 'Order', foreign_key: :maker_order_id, required: true
  belongs_to :taker_order, class_name: 'Order', foreign_key: :taker_order_id, required: true
  belongs_to :maker, class_name: 'Member', foreign_key: :maker_id, required: true
  belongs_to :taker, class_name: 'Member', foreign_key: :taker_id, required: true

  has_many :operations_revenues, as: :reference, class_name: 'Operations::Revenue'

  # == Scopes ===============================================================

  scope :h24, -> { where('created_at > ?', 24.hours.ago) }
  scope :with_market, ->(market) { where(market_id: market) }
  scope :by_member, ->(member_id) { where 'taker_id=? or maker_id=?', member_id, member_id }

  # == Class Methods ========================================================

  class << self
    def to_csv
      attributes = %w[id price amount maker_order_id taker_order_id market_id maker_id taker_id total created_at
                      updated_at]
      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.each do |trade|
          data = attributes[0...-2].map { |attr| trade.send(attr) }
          data += attributes[-2..].map { |attr| trade.send(attr).iso8601 }
          csv << data
        end
      end
    end

    def public_from_influx(market, limit = 100, options = {})
      trades_query = ['SELECT id, price, amount, total, taker_type, market, created_at FROM trades WHERE market=%{market}']
      trades_query << 'AND taker_type=%{type}' if options[:type].present?
      trades_query << 'AND created_at>=%{start_time}' if options[:start_time].present?
      trades_query << 'AND created_at<=%{end_time}' if options[:end_time].present?
      trades_query << 'AND price=%{price_eq}' if options[:price_eq].present?
      trades_query << 'AND price>=%{price_gt}' if options[:price_gt].present?
      trades_query << 'AND price=%{price_lt}' if options[:price_lt].present?
      trades_query << 'ORDER BY desc'

      unless limit.to_i.zero?
        trades_query << 'LIMIT %{limit}'
        options.merge!(limit: limit)
      end

      Peatio::InfluxDB.client(keyshard: market).query trades_query.join(' '),
                                                      params: options.merge(market: market) do |_name, _tags, points|
        return points.map(&:deep_symbolize_keys!)
      end
    end

    # Low, High, First, Last, sum total (amount * price), sum 24 hours amount and average 24 hours price calculated using VWAP ratio for 24 hours trades
    def market_ticker_from_influx(market)
      tickers_query = 'SELECT MIN(price), MAX(price), FIRST(price), LAST(price), SUM(total) AS volume, SUM(amount) AS amount, SUM(total) / SUM(amount) AS vwap FROM trades WHERE market=%{market} AND time > now() - 24h'
      Peatio::InfluxDB.client(keyshard: market).query tickers_query,
                                                      params: { market: market } do |_name, _tags, points|
        return points.map(&:deep_symbolize_keys!).first
      end
    end

    def trade_from_influx_before_date(market, date)
      trades_query = 'SELECT id, price, amount, total, taker_type, market, created_at FROM trades WHERE market=%{market} AND created_at < %{date} ORDER BY DESC LIMIT 1 '
      Peatio::InfluxDB.client(keyshard: market).query trades_query,
                                                      params: { market: market,
                                                                date: date.to_i } do |_name, _tags, points|
        return points.map(&:deep_symbolize_keys!).first
      end
    end

    def trade_from_influx_after_date(market, date)
      trades_query = 'SELECT id, price, amount, total, taker_type, market, created_at FROM trades WHERE market=%{market} AND created_at >= %{date} ORDER BY ASC LIMIT 1 '
      Peatio::InfluxDB.client(keyshard: market).query trades_query,
                                                      params: { market: market,
                                                                date: date.to_i } do |_name, _tags, points|
        return points.map(&:deep_symbolize_keys!).first
      end
    end

    def nearest_trade_from_influx(market, date)
      res = trade_from_influx_before_date(market, date)
      res.blank? ? trade_from_influx_after_date(market, date) : res
    end
  end

  def taker_fee_amount
    total * taker_order.taker_fee
  end

  def maker_fee_amount
    amount * taker_order.maker_fee
  end

  # == Instance Methods =====================================================

  def order_fee(order)
    maker_order_id == order.id ? order.maker_fee : order.taker_fee
  end

  def side(member)
    return unless member

    order_for_member(member).side
  end

  def order_for_member(member)
    return unless member

    if member.id == maker_id
      maker_order
    elsif member.id == taker_id
      taker_order
    end
  end

  def sell_order
    [maker_order, taker_order].find { |o| o.side == 'sell' }
  end

  def buy_order
    [maker_order, taker_order].find { |o| o.side == 'buy' }
  end
end

# == Schema Information
# Schema version: 20210120133912
#
# Table name: trades
#
#  id             :integer          not null, primary key
#  price          :decimal(32, 16)  not null
#  amount         :decimal(32, 16)  not null
#  total          :decimal(32, 16)  default(0.0), not null
#  maker_order_id :integer          not null
#  taker_order_id :integer          not null
#  market_id      :string(20)       not null
#  maker_id       :integer          not null
#  taker_id       :integer          not null
#  taker_type     :string(20)       default(""), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_trades_on_created_at                (created_at)
#  index_trades_on_maker_id                  (maker_id)
#  index_trades_on_maker_order_id            (maker_order_id)
#  index_trades_on_market_id_and_created_at  (market_id,created_at)
#  index_trades_on_taker_id                  (taker_id)
#  index_trades_on_taker_order_id            (taker_order_id)
#
