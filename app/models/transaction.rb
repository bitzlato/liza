# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Transaction < ApplicationRecord
  # == Constants ============================================================

  PENDING_STATUS = 'pending'
  SUCCESS_STATUS = 'success'
  FAIL_STATUS = 'failed'
  STATUSES = [PENDING_STATUS, SUCCESS_STATUS, FAIL_STATUS].freeze

  STATUSES.each do |status|
    scope status, -> { where status: status }
  end

  # TODO fee payed by us
  scope :accountable_fee, -> { where accountable_fee: true }
  # TODO blockchain normalize
  scope :by_address, -> (address) { where 'lower(from_address) = ? or lower(to_address) = ?', address, address }

  belongs_to :reference, polymorphic: true
  belongs_to :currency
  belongs_to :blockchain

  def self.ransackable_scopes(auth_object = nil)
    %w(by_address)
  end

  def transaction_url
    blockchain&.explore_transaction_url txid
  end
end
