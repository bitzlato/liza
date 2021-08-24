# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WithdrawDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member created_at updated_at currency aasm_state sum amount fee type txid tid rid note beneficiary transfer_type error note]
  end

  def sum
    h.format_money object.sum, object.currency
  end

  def amount
    h.format_money object.amount, object.currency
  end

  def txid
    txid_with_recorded_transaction object.txid
  end
end
