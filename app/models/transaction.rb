class Transaction < ApplicationRecord
  # == Constants ============================================================

  STATUSES = %w[pending succeed].freeze

  # == Relationships ========================================================

  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id
end
