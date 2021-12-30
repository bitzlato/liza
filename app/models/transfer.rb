# frozen_string_literal: true

class Transfer < PeatioRecord
  extend Enumerize
  include OperationsReferences

  CATEGORIES = %w[wire refund purchases commission airdrop p2p].freeze
  CATEGORIES_MAPPING = { wire: 1, refund: 2, purchases: 3, commission: 4, airdrop: 5, p2p: 6 }.freeze

  enumerize :category, in: CATEGORIES_MAPPING, scope: true

  #scope :with_revenues_liabilities_amount, -> {
  #  joins(:operations_revenue, :operations_liabilities)
  #    .select(["transfers.*", "revenues.credit - revenues.debit as revenue_amount", "liabilities.credit - liabilities.debit as liability_amount"])
  #}

  def revenues_amount
    operations_revenue.sum(:credit) - operations_revenue.sum(:debit)
  end

  def liability_amount
    operations_liabilities.sum(:credit) - operations_liabilities.sum(:debit)
  end
end
