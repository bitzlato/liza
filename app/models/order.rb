# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'csv'

class Order < PeatioRecord
  attribute :uuid, :uuid if Rails.configuration.database_adapter.downcase != 'PostgreSQL'.downcase

  # Error is raised in case market doesn't have enough volume to fulfill the Order.
  InsufficientMarketLiquidity = Class.new(StandardError)

  extend Enumerize
  STATES = { pending: 0, wait: 100, done: 200, cancel: -100, reject: -200 }.freeze
  enumerize :state, in: STATES, scope: true

  TYPES = %w[market limit].freeze

  THIRD_PARTY_ORDER_ACTION_TYPE = {
    'submit_single' => 0,
    'cancel_single' => 3,
    'cancel_bulk' => 4
  }.freeze

  belongs_to :market, required: true, primary_key: :symbol
  belongs_to :member, required: true
  belongs_to :ask_currency, class_name: 'Currency', foreign_key: :ask
  belongs_to :bid_currency, class_name: 'Currency', foreign_key: :bid

  attr_readonly :member_id,
                :bid,
                :ask,
                :market_id,
                :ord_type,
                :origin_volume,
                :origin_locked,
                :created_at

  PENDING = 'pending'
  WAIT    = 'wait'
  DONE    = 'done'
  CANCEL  = 'cancel'
  REJECT  = 'reject'

  scope :done, -> { with_state(:done) }
  scope :active, -> { with_state(:wait) }
  scope :with_market, ->(market) { where(market_id: market) }

  # Custom ransackers.

  ransacker :state, formatter: proc { |v| STATES[v.to_sym] } do |parent|
    parent.table[:state]
  end

  def price_currency
    is_a?(OrderAsk) ? bid_currency  : ask_currency
  end

  def volume_currency
    is_a?(OrderBid) ? bid_currency  : ask_currency
  end

  def trades
    Trade.where('maker_order_id = ? OR taker_order_id = ?', id, id)
  end

  def funds_used
    origin_locked - locked
  end

  def side
    self.class.name.underscore[-3, 3] == 'ask' ? 'sell' : 'buy'
  end

  # @deprecated Please use {#side} instead
  def kind
    self.class.name.underscore[-3, 3]
  end

  # @deprecated Please use {#created_at} instead
  def at
    created_at.to_i
  end

  # @deprecated
  def round_amount_and_price
    self.price = market.round_price(price.to_d) if price

    if volume
      self.volume = market.round_amount(volume.to_d)
      self.origin_volume = origin_volume.present? ? market.round_amount(origin_volume.to_d) : volume
    end
  end

  def limit_order?
    ord_type == 'limit'
  end

  def member_balance
    member.get_account(currency).balance
  end

  private

  def market_order_validations
    errors.add(:price, 'must not be present') if price.present?
  end

  FUSE = '0.9'.to_d
  def estimate_required_funds(price_levels)
    required_funds = Account::ZERO
    expected_volume = volume

    until expected_volume.zero? || price_levels.empty?
      level_price, level_volume = price_levels.shift

      v = [expected_volume, level_volume].min
      required_funds += yield level_price, v
      expected_volume -= v
    end

    raise InsufficientMarketLiquidity if expected_volume.nonzero?

    required_funds
  end
end
