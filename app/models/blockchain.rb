# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Blockchain < PeatioRecord
  include BlockchainExploring

  has_many :wallets
  has_many :withdraws
  has_many :blockchain_currencies
  has_many :currencies, through: :blockchain_currencies
  has_many :payment_addresses
  has_many :transactions
  has_many :block_numbers

  def native_currency
    blockchain_currencies.find_by(parent_id: nil)&.currency || raise("No native currency for blockchain id #{id}")
  end

  def scan_latest_block
    @scan_latest_block ||= service.scan_latest_block
  end

  def fee_currency
    native_currency
  end

  def block_numbers_agg
    block_numbers.reorder('').pluck('min(number), max(number), count(number)').first
  end

  def service
    @service ||= BlockchainService.new(self)
  end

  def to_s
    key
  end
end
