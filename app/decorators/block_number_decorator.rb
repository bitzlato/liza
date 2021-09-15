class BlockNumberDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[blockchain_id number status transactions_processed_count created_at updated_at]
  end

  def transactions_processed_count
    h.link_to object.transactions_processed_count,
      transactions_path(q: { blockchain_id_eq: object.blockchain_id, block_number_eq: object.number })
  end
end
