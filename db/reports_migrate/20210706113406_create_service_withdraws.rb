# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateServiceWithdraws < ActiveRecord::Migration[6.1]
  def change
    create_table :service_withdraws do |t|
      t.integer :wallet_id, null: false
      t.string :public_name, null: false
      t.decimal :amount, null: false
      t.string :currency, null: false
      t.string :withdraw_type, null: false
      t.string :status, null: false
      t.timestamp :date, null: false
      t.integer :withdraw_id

      t.timestamps
    end

    add_index :service_withdraws, %i[wallet_id withdraw_id], unique: true
  end
end
