# frozen_string_literal: true

# {Operation} provides generic methods for the accounting operations
# models.
# @abstract
class Operation < ApplicationRecord
  belongs_to :reference, polymorphic: true
  belongs_to :currency, foreign_key: :currency_id
  belongs_to :account, class_name: 'Operations::Account',
                       foreign_key: :code, primary_key: :code

  self.abstract_class = true

  # Returns operation amount with sign.
  def amount
    credit.zero? ? -debit : credit
  end

  class << self
    def operation_type
      name.demodulize.downcase
    end

    def balance(currency: nil, created_at_from: nil, created_at_to: nil)
      if currency.blank?
        db_balances = all
        db_balances = db_balances.where('created_at > ?', created_at_from) if created_at_from.present?
        db_balances = db_balances.where('created_at < ?', created_at_to) if created_at_to.present?
        db_balances = db_balances.group(:currency_id)
                                 .sum('credit - debit')

        Currency.ids.map(&:to_sym).each_with_object({}) do |id, memo|
          memo[id] = db_balances[id.to_s] || 0
        end
      else
        where(currency: currency).sum('credit - debit')
      end
    end
  end
end
