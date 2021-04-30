# frozen_string_literal: true

class Currency < ApplicationRecord
  extend Memoist

  attr_readonly :id,
                :type,
                :base_factor

  # Code is aliased to id because it's more user-friendly primary key.
  # It's preferred to use code where this attributes are equal.
  alias_attribute :code, :id

  serialize :options, JSON unless Rails.configuration.database_support_json

  belongs_to :blockchain, foreign_key: :blockchain_key, primary_key: :key
  has_and_belongs_to_many :wallets
  has_one :parent, class_name: 'Currency', foreign_key: :id, primary_key: :parent_id
  has_many :operations_revenues, class_name: 'Operations::Revenue'
  has_many :operations_assets, class_name: 'Operations::Asset'
  has_many :base_markets, class_name: 'Market', foreign_key: :base_unit
  has_many :quote_markets, class_name: 'Market', foreign_key: :quote_unit
  has_many :adjustments

  scope :visible, -> { where(visible: true) }
  scope :deposit_enabled, -> { where(deposit_enabled: true) }
  scope :withdrawal_enabled, -> { where(withdrawal_enabled: true) }
  scope :ordered, -> { order(position: :asc) }
  scope :coins, -> { where(type: :coin) }
  scope :fiats, -> { where(type: :fiat) }
  # This scope select all coins without parent_id, which means that they are not tokens
  scope :coins_without_tokens, -> { coins.where(parent_id: nil) }

  # NOTE: type column reserved for STI
  self.inheritance_column = nil

  # subunit (or fractional monetary unit) - a monetary unit
  # that is valued at a fraction (usually one hundredth)
  # of the basic monetary unit
  def subunits=(n)
    self.base_factor = 10**n
  end

  # This method defines that token currency need to have parent_id and coin type
  # We use parent_id for token type to inherit some useful info such as blockchain_key from parent currency
  # For coin currency enough to have only coin type
  def token?
    parent_id.present? && coin?
  end

  def to_s
    id.upcase
  end

  def dependent_markets
    Market.where('base_unit = ? OR quote_unit = ?', id, id)
  end

  def subunits
    Math.log(base_factor, 10).round
  end

  def total_completed_deposits
    Deposit.completed.where(currency_id: id).sum(:amount)
  end
  memoize :total_completed_deposits

  def total_completed_withdraws
    Withdraw.completed.where(currency_id: id).sum(:amount)
  end
  memoize :total_completed_withdraws

  def estimated_amount
    total_completed_deposits - total_completed_withdraws
  end
end
