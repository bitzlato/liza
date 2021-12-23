# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WithdrawDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member_uid member created_at updated_at currency aasm_state sum amount fee is_locked type txid tid rid note beneficiary transfer_type error note tx_dump]
  end

  def tx_dump
    h.content_tag :span, object.tx_dump.as_json, class: 'text-small text-muted text-monospace'
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

  def member_uid
    object.member.uid
  end
end
