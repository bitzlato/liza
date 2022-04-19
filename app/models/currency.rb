# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Currency < PeatioRecord
  extend Memoist

  attr_readonly :id,
                :type

  # Code is aliased to id because it's more user-friendly primary key.
  # It's preferred to use code where this attributes are equal.
  alias_attribute :code, :id

  has_many :operations_revenues, class_name: 'Operations::Revenue'
  has_many :operations_assets, class_name: 'Operations::Asset'
  has_many :base_markets, class_name: 'Market', foreign_key: :base_unit
  has_many :quote_markets, class_name: 'Market', foreign_key: :quote_unit
  has_many :adjustments
  has_many :merged_tokens, class_name: 'Currency', foreign_key: :merged_token_id

  scope :visible, -> { where(visible: true) }
  scope :hidden, -> { where(visible: false) }
  scope :deposit_enabled, -> { where(deposit_enabled: true) }
  scope :withdrawal_enabled, -> { where(withdrawal_enabled: true) }
  scope :ordered, -> { order(position: :asc) }
  scope :coins, -> { where(type: :coin) }
  scope :fiats, -> { where(type: :fiat) }

  # NOTE: type column reserved for STI
  self.inheritance_column = nil

  def to_s
    id.upcase
  end

  def dependent_markets
    Market.where('base_unit = ? OR quote_unit = ?', id, id)
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
