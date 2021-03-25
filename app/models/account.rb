# frozen_string_literal: true

class Account < ApplicationRecord
  belongs_to :currency, required: true
  belongs_to :member, required: true

  scope :visible, -> { joins(:currency).merge(Currency.where(visible: true)) }
  scope :ordered, -> { joins(:currency).order(position: :asc) }

  def amount
    balance + locked
  end
end
