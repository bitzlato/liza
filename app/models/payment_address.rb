# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# TODO: Rename to DepositAddress
class PaymentAddress < ApplicationRecord
  extend PaymentAddressTotals

  belongs_to :member
  belongs_to :blockchain

  delegate :currencies, :native_currency, to: :blockchain

  # TODO: migrate to
  # SELECT "key", sum("val"::decimal)
  # FROM payment_addresses,
  # LATERAL jsonb_each_text(balances) AS each(KEY,val) GROUP BY "key"

  def format_address(format)
    format == 'legacy' ? to_legacy_address : to_cash_address
  end

  def to_legacy_address
    CashAddr::Converter.to_legacy_address(address)
  end

  def to_cash_address
    CashAddr::Converter.to_cash_address(address)
  end

  def address_url
    blockchain&.explore_address_url address
  end
end
