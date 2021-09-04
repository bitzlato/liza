class BlockNumberDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[blockchain_id number status created_at updated_at]
  end
end
