# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id currency created_at amount balance locked]
  end

  def amount
    h.format_money object.amount, object.currency
  end

  def balance
    h.format_money object.balance, object.currency
  end

  def locked
    h.format_money object.locked, object.currency
  end
end
