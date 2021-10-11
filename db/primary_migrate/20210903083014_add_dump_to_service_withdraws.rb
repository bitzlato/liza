class AddDumpToServiceWithdraws < ActiveRecord::Migration[6.1]
  def change
    add_column :service_withdraws, :dump, :jsonb
  end
end
