# frozen_string_literal: true

class Account < ApplicationRecord
  extend Memoist

  belongs_to :currency, required: true
  belongs_to :member, required: true
  has_many :withdraws, -> { order(id: :desc) }, through: :member
  has_many :deposits, -> { order(id: :desc) }, through: :member
  has_many :beneficiaries, -> { order(id: :desc) }, through: :member


  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

  def amount
    balance + locked
  end

  def total_deposit_amount
    deposits.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_deposit_amount

  def total_withdraw_amount
    withdraws.completed.where(currency_id: currency_id).sum(:amount)
  end
  memoize :total_withdraw_amount

  def estimated_amount
    total_deposit_amount - total_withdraw_amount
  end
end
