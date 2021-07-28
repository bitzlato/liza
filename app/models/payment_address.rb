# encoding: UTF-8
# frozen_string_literal: true

# TODO: Rename to DepositAddress
class PaymentAddress < ApplicationRecord
  belongs_to :wallet
  belongs_to :member

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
