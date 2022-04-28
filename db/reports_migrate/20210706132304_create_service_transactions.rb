# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateServiceTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :service_transactions do |t|
      t.integer :wallet_id, null: false
      t.decimal :amount, null: false
      t.bigint :telegram_id
      t.string :username, null: false
      t.string :currency_id, null: false
      t.timestamp :transaction_created_at, null: false
      t.integer :invoice_id, null: false

      t.timestamps
    end

    add_index :service_transactions, %i[wallet_id invoice_id], unique: true
    add_index :service_transactions, :currency_id
  end
end
