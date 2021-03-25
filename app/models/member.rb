# encoding: UTF-8
# frozen_string_literal: true

class Member < ApplicationRecord
  has_many :orders
  has_many :accounts
  has_many :stats_member_pnl
  has_many :payment_addresses
  has_many :withdraws, -> { order(id: :desc) }
  has_many :deposits, -> { order(id: :desc) }
  has_many :beneficiaries, -> { order(id: :desc) }

  scope :enabled, -> { where(state: 'active') }

  def trades
    Trade.where('maker_id = ? OR taker_id = ?', id, id)
  end

  def get_account(model_or_id_or_code)
    if model_or_id_or_code.is_a?(String) || model_or_id_or_code.is_a?(Symbol)
      accounts.find_or_create_by(currency_id: model_or_id_or_code)
    elsif model_or_id_or_code.is_a?(Currency)
      accounts.find_or_create_by(currency: model_or_id_or_code)
    end
  # Thread Safe Account creation
  rescue ActiveRecord::RecordNotUnique
    if model_or_id_or_code.is_a?(String) || model_or_id_or_code.is_a?(Symbol)
      accounts.find_by(currency_id: model_or_id_or_code)
    elsif model_or_id_or_code.is_a?(Currency)
      accounts.find_by(currency: model_or_id_or_code)
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
