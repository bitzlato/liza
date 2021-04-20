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
end
