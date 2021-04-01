# frozen_string_literal: true

# People exchange commodities in markets. Each market focuses on certain
# commodity pair `{A, B}`. By convention, we call people exchange A for B
# *sellers* who submit *ask* orders, and people exchange B for A *buyers*
# who submit *bid* orders.
#
# ID of market is always in the form "#{B}#{A}". For example, in 'btcusd'
# market, the commodity pair is `{btc, usd}`. Sellers sell out _btc_ for
# _usd_, buyers buy in _btc_ with _usd_. _btc_ is the `base_unit`, while
# _usd_ is the `quote_unit`.
#
# Given market BTCUSD.
# Ask/Base currency/unit = BTC.
# Bid/Quote currency/unit = USD.

class Market < ApplicationRecord
  # == Constants ============================================================

  # Since we use decimal with 16 digits fractional part for storing numbers in DB
  # sum of multipliers fractional parts must not be greater then 16.
  # In the worst situation we have 3 multipliers (price * amount * fee).
  # For fee we define static precision - 6. See TradingFee::FEE_PRECISION.
  # So 10 left for amount and price precision.
  DB_DECIMAL_PRECISION = 16
  FUNDS_PRECISION = 10
  TOP_POSITION = 1

  STATES = %w[enabled disabled hidden locked sale presale].freeze
  # enabled - user can view and trade.
  # disabled - none can trade, user can't view.
  # hidden - user can't view but can trade.
  # locked - user can view but can't trade.
  # sale - user can't view but can trade with market orders.
  # presale - user can't view and trade. Admin can trade.

  # == Attributes ===========================================================

  attr_readonly :base_unit, :quote_unit

  # base_currency & quote_currency is preferred names instead of legacy
  # base_unit & quote_unit.
  # For avoiding DB migration and config we use alias as temporary solution.
  alias_attribute :base_currency, :base_unit
  alias_attribute :quote_currency, :quote_unit

  # == Extensions ===========================================================

  serialize :data, JSON unless Rails.configuration.database_support_json

  # == Relationships ========================================================

  has_one :base, class_name: 'Currency', foreign_key: :id, primary_key: :base_unit
  has_one :quote, class_name: 'Currency', foreign_key: :id, primary_key: :quote_unit
  belongs_to :engine, required: true

  has_many :trading_fees, dependent: :delete_all

  # == Scopes ===============================================================

  scope :ordered, -> { order(position: :asc) }
  scope :active, -> { where(state: %i[enabled hidden]) }
  scope :enabled, -> { where(state: :enabled) }

  def name
    "#{base_currency}/#{quote_currency}".upcase
  end

  def underscore_name
    "#{base_currency.upcase}_#{quote_currency.upcase}"
  end

  alias to_s name

  def round_amount(d)
    d.round(amount_precision, BigDecimal::ROUND_DOWN)
  end

  def round_price(d)
    d.round(price_precision, BigDecimal::ROUND_DOWN)
  end

  def unit_info
    { name: name, base_unit: base_currency, quote_unit: quote_currency }
  end

  # min_amount_by_precision - is the smallest positive number which could be
  # rounded to value greater then 0 with precision defined by
  # Market #amount_precision. So min_amount_by_precision is the smallest amount
  # of order/trade for current market.
  # E.g.
  #   market.amount_precision => 4
  #   min_amount_by_precision => 0.0001
  #
  #   market.amount_precision => 2
  #   min_amount_by_precision => 0.01
  #
  def min_amount_by_precision
    0.1.to_d**amount_precision
  end

  # See #min_amount_by_precision.
  def min_price_by_precision
    0.1.to_d**price_precision
  end
end
