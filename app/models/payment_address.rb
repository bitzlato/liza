# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# TODO: Rename to DepositAddress
class PaymentAddress < ApplicationRecord
  belongs_to :member
  belongs_to :blockchain

  delegate :currencies, :native_currency, to: :blockchain

  def self.total_balances
    total_currencies.each_with_object({}) do |currency, agg|
      agg[currency] = total_balance(currency)
    end
  end

  def self.total_currencies
    PaymentAddress.group(:currency_id).pluck('jsonb_object_keys(balances) as currency_id')
  end

  def self.total_balance(currency_id)
    PaymentAddress.select("sum((balances ->> '#{currency_id.downcase}') :: decimal) as balance").take.attributes['balance']
  end

  def format_address(format)
    format == 'legacy' ? to_legacy_address : to_cash_address
  end

  def to_legacy_address
    CashAddr::Converter.to_legacy_address(address)
  end

  def to_cash_address
    CashAddr::Converter.to_cash_address(address)
  end
end
