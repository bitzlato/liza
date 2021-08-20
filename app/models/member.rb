# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :orders
  has_many :accounts
  # has_many :stats_member_pnl
  has_many :payment_addresses
  has_many :withdraws, -> { order(id: :desc) }
  has_many :deposits, -> { order(id: :desc) }
  has_many :beneficiaries, -> { order(id: :desc) }
  has_many :operations_revenues, class_name: 'Operations::Revenue'

  scope :enabled, -> { where(state: 'active') }

  def trades
    Trade.by_member(id)
  end

  def to_s
    uid
  end

  def title
    email
  end

  def get_account(model_or_id_or_code)
    case model_or_id_or_code
    when String, Symbol
      accounts.find_by(currency_id: model_or_id_or_code)
    when Currency
      accounts.find_by(currency: model_or_id_or_code)
    else
      raise "Unknown type #{model_or_id_or_code}"
    end
  end

  def balance_for(currency:, kind:)
    account_code = Operations::Account.find_by(
      type: :liability,
      kind: kind,
      currency_type: currency.type
    ).code
    liabilities = Operations::Liability.where(member_id: id, currency: currency, code: account_code)
    liabilities.sum('credit - debit')
  end
end
