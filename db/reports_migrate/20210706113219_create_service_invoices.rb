# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateServiceInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :service_invoices do |t|
      t.integer :wallet_id, null: false
      t.decimal :amount, null: false
      t.string :currency_id, null: false
      t.timestamp :completed_at
      t.timestamp :invoice_created_at, null: false
      t.timestamp :expiry_at, null: false
      t.integer :invoice_id, null: false
      t.string :comment, null: false
      t.string :status, null: false

      t.timestamps
    end

    add_index :service_invoices, %i[wallet_id invoice_id], unique: true
  end
end
