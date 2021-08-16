module OperationsReferences
  extend ActiveSupport::Concern
  included do
    has_many :operations_assets, as: :reference, class_name: 'Operations::Asset'
    has_many :operations_expenses, as: :reference, class_name: 'Operations::Expense'
    has_many :operations_liabilities, as: :reference, class_name: 'Operations::Liability'
    has_many :operations_revenue, as: :reference, class_name: 'Operations::Revenue'
  end

  def operations
    operations_assets + operations_expenses + operations_liabilities + operations_revenue
  end
end
