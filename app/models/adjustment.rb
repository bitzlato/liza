# encoding: UTF-8
# frozen_string_literal: true

class Adjustment < ApplicationRecord
  # == Constants ============================================================

  CATEGORIES = %w[asset_registration investment minting_token
                  balance_anomaly misc refund compensation
                  incentive bank_fees bank_interest minor].freeze

  # == Attributes ===========================================================

  enum category: CATEGORIES

  enum state: { pending: 1, accepted: 2, rejected: 3 }

  # == Relationships ========================================================

  belongs_to :currency
  belongs_to :creator, class_name: :Member, required: true
  belongs_to :validator, class_name: :Member
  belongs_to :asset_account, primary_key: :code, foreign_key: :asset_account_code, class_name: 'Operations::Account'

  # Define has_one relation with Operations::{Asset,Expense,Liability,Revenue}.
  ::Operations::Account::TYPES.each do |op_t|
    has_one op_t.to_sym,
            class_name: "::Operations::#{op_t.to_s.camelize}",
            as: :reference
  end

  # Custom ransackers.

  ransacker :state, formatter: proc { |v| states[v] } do |parent|
    parent.table[:state]
  end

  ransacker :category, formatter: proc { |v| categories[v] } do |parent|
    parent.table[:category]
  end

  def fetch_operations
    if pending? || rejected?
      prebuild_operations
    elsif accepted?
      load_operations
    end
  end

  def load_operations
    operations = %i[asset liability revenue expense].map do |op_type|
      "Operations::#{op_type.capitalize}".constantize.find_by(reference: self)
    end
    operations.compact
  end

  %i[asset liability revenue expense].each do |op_type|
    define_method("fetch_#{op_type}") do
      fetch_operations.find { |op| op.is_a?("Operations::#{op_type.capitalize}".constantize) }
    end
  end
end
