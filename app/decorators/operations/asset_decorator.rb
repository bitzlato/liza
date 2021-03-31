class Operations::AssetDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[code created_at currency reference debit credit]
  end

  def credit
    h.format_money object.credit, object.currency
  end

  def debit
    h.format_money object.debit, object.currency
  end

  def reference
    h.present_liability_reference object.reference
  end
end
