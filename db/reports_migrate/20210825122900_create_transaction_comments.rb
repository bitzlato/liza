# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CreateTransactionComments < ActiveRecord::Migration[6.1]
  def change
    create_table :transaction_comments do |t|
      t.text :comment

      t.timestamps
    end
  end
end
