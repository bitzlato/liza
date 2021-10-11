# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class IndexByDateInServiceWithdraws < ActiveRecord::Migration[6.1]
  def change
    add_index :service_withdraws, :date
    add_index :service_transactions, :transaction_created_at
  end
end
