# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Trade < PeatioRecord
  # == Constants ============================================================

  extend Enumerize
  ZERO = '0.0'.to_d

  # == Relationships ========================================================

  belongs_to :market, required: true, primary_key: :symbol
  belongs_to :maker_order, class_name: 'Order', foreign_key: :maker_order_id, required: true
  belongs_to :taker_order, class_name: 'Order', foreign_key: :taker_order_id, required: true
  belongs_to :maker, class_name: 'Member', foreign_key: :maker_id, required: true
  belongs_to :taker, class_name: 'Member', foreign_key: :taker_id, required: true

  has_many :operations_revenues, as: :reference, class_name: 'Operations::Revenue'

  # == Scopes ===============================================================

  scope :h24, -> { where('created_at > ?', 24.hours.ago) }
  scope :with_market, ->(market) { where(market_id: market) }
  scope :by_member, ->(member_id) { where 'taker_id=? or maker_id=?', member_id, member_id }

  scope :user_trades, -> do
    ids = Member.bots.ids
    where('maker_id not in (?) or taker_id not in (?)', ids, ids)
  end

  scope :user_taker_trades, -> do
    ids = Member.bots.ids
    where('taker_id not in (?)', ids)
  end

  scope :user_maker_trades, -> do
    ids = Member.bots.ids
    where('maker_id not in (?)', ids)
  end

  scope :bot_trades, -> do
    where(maker_id: Member.bots.ids, taker_id: Member.bots.ids)
  end

  def self.swap_trades
    taker = Trade.joins(taker_order: :swap_order).where(swap_order: { state: 200})
    maker = Trade.joins(maker_order: :swap_order).where(swap_order: { state: 200})

    Trade.all.union(taker, maker)
  end

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

    def self.ransackable_scopes(_auth_object = nil)
      %i[by_member]
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

  def seller
    sell_order.member
  end

  def buyer
    buy_order.member
  end

  def seller_fee
    total * order_fee(sell_order)
  end

  def buyer_fee
    amount * order_fee(buy_order)
  end
end
