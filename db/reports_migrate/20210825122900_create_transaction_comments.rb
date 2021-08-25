class CreateTransactionComments < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_comments do |t|
      t.text :comment

      t.timestamps
    end
  end
end
