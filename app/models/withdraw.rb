# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Withdraw < ApplicationRecord
  self.inheritance_column = nil
  STATES = %i[prepared rejected accepted skipped processing succeed canceled failed errored confirming].freeze
  COMPLETED_STATES = %i[succeed rejected canceled failed].freeze
  SUCCEED_PROCESSING_STATES = %i[prepared accepted skipped processing errored confirming succeed].freeze
  SUCCESS_STATES = %i[succeed].freeze

  self.inheritance_column = :fake_type

  extend Enumerize
  include OperationsReferences

  serialize :error, JSON unless Rails.configuration.database_support_json
  serialize :metadata, JSON unless Rails.configuration.database_support_json

  TRANSFER_TYPES = { fiat: 100, crypto: 200 }.freeze

  enumerize :aasm_state, in: STATES, predicates: true

  belongs_to :currency, required: true
  belongs_to :member, required: true
  belongs_to :blockchain, required: true, touch: false

  # Optional beneficiary association gives ability to support both in-peatio
  # beneficiaries and managed by third party application.
  belongs_to :beneficiary, optional: true

  has_many :operations_assets, as: :reference, class_name: 'Operations::Asset'

  scope :success, -> { where aasm_state: SUCCESS_STATES }
  scope :completed, -> { where(aasm_state: COMPLETED_STATES) }
  scope :uncompleted, -> { where.not(aasm_state: COMPLETED_STATES) }
  scope :succeed_processing, -> { where(aasm_state: SUCCEED_PROCESSING_STATES) }
  scope :last_24_hours, -> { where('created_at > ?', 24.hour.ago) }
  scope :last_1_month, -> { where('created_at > ?', 1.month.ago) }

  class << self
    def sum_query
      'SELECT sum(w.sum * c.price) as sum FROM withdraws as w ' \
      'INNER JOIN currencies as c ON c.id=w.currency_id ' \
      'where w.member_id = ? AND w.aasm_state IN (?) AND w.created_at > ?;'
    end

    def sanitize_execute_sum_queries(member_id)
      squery_24h = ActiveRecord::Base.sanitize_sql_for_conditions([sum_query, member_id, SUCCEED_PROCESSING_STATES,
                                                                   24.hours.ago])
      squery_1m = ActiveRecord::Base.sanitize_sql_for_conditions([sum_query, member_id, SUCCEED_PROCESSING_STATES,
                                                                  1.month.ago])
      sum_withdraws_24_hours = ActiveRecord::Base.connection.exec_query(squery_24h).to_hash.first['sum'].to_d
      sum_withdraws_1_month = ActiveRecord::Base.connection.exec_query(squery_1m).to_hash.first['sum'].to_d
      [sum_withdraws_24_hours, sum_withdraws_1_month]
    end

    def find_by_address(address)
      where('lower(rid)=?', address.downcase).take
    end
  end

  def to_s
    ['withdraw#', id.to_s, ' ', amount.to_s, ' ', currency_id].join
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

  def recorded_transaction
    blockchain.transactions.find_by(txid: txid)
  end

  def self.ransackable_scopes(auth_object = nil)
    %i[uncompleted completed] + super
  end
end
