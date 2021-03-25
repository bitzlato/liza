# frozen_string_literal: true

class Account < ApplicationRecord
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
end
