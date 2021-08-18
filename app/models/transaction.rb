# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Transaction < ApplicationRecord
  # == Constants ============================================================

  STATUSES = %w[pending succeed].freeze

  # == Relationships ========================================================

  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id
  has_one :blockchain, through: :currency

  def transaction_url
    blockchain.explore_transaction_url txid if blockchain
  end
end
