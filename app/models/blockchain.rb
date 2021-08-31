# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class Blockchain < ApplicationRecord
  include BlockchainExploring

  has_many :wallets
  has_many :withdraws
  has_many :currencies
  has_many :payment_addresses
  has_many :transactions
  has_many :deposits, through: :currencies

  def native_currency
    currencies.find { |c| c.parent_id.nil? } || raise("No native currency for wallet id #{id}")
  end

  def scan_latest_block
    @scan_latest_block ||= service.scan_latest_block
  end

  def fee_currency
    native_currency
  end

  def service
    @service ||= BlockchainService.new(self)
  end

  def to_s
    key
  end
end
