class BitzlatoWalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id user_id balance hold_balance debt cc_code created_at updated_at]
  end
end
