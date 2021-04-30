class AdjustmentDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at updated_at creator validator amount receiving_account_number asset_account asset_account_code category state reason description]
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
