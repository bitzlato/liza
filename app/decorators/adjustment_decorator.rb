# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AdjustmentDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[
    id created_at updated_at creator validator amount receiving_account_number member asset_account asset_account_code category state reason description
]
  end

  def member
    h.render 'member_brief', member: object.receiving_member
  end

  def creator
    h.render 'member_brief', member: object.creator
  end

  def validator
    h.render 'member_brief', member: object.validator
  end

  def amount
    h.format_money object.amount, object.currency
  end

  def asset_account
    h.format_liability_account object.asset_account
  end
end
