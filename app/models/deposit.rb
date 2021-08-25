# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Deposit < ApplicationRecord
  COMPLETED_STATES = %i[dispatched].freeze
  TRANSFER_TYPES = { fiat: 100, crypto: 200 }.freeze

  self.inheritance_column = :fake_type

  serialize :spread, Array
  serialize :from_addresses, Array
  serialize :data, JSON unless Rails.configuration.database_support_json

  extend Enumerize
  include OperationsReferences

  belongs_to :currency, required: true
  belongs_to :member, required: true
  belongs_to :blockchain
  has_one :recorded_transaction, through: :blockchain, source: :transactions, class_name: 'Transaction', primary_key: :txid

  scope :success, -> { completed }
  scope :completed, -> { where aasm_state: COMPLETED_STATES }
  scope :uncompleted, -> { where.not(aasm_state: COMPLETED_STATES) }

  scope :recent, -> { order(id: :desc) }

  def to_s
    ['deposit#', id.to_s, ' ', amount.to_s, ' ', currency_id].join
  end

  def transaction_url
    return if txid.nil?

    blockchain&.explore_transaction_url txid
  end

  def account
    member&.get_account(currency)
  end

  def completed?
    aasm_state.in?(COMPLETED_STATES.map(&:to_s))
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[uncompleted completed] + super
  end
end
