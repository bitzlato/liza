# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class DepositDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member created_at updated_at currency aasm_state invoice_expires_at amount fee txid txout tid transfer_type address invoice_id data]
  end

  def id
    h.content_tag :span, object.id, title: object.type
  end

  def data
    h.content_tag :span, 'data', title: object.data
  end

  def txid
    txid_with_recorded_transaction object.txid
  end
end
