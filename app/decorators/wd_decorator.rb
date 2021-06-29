# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WdDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at type amount]
  end

  def self.object_class
    Deposit
  end

  def self.table_tr_class(record)
    record.is_a?(Deposit) ? 'bg-success' : 'bg-danger'
  end

  def amount
    h.format_money object.amount, object.currency_id
  end
end
