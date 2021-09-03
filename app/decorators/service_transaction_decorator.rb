# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceTransactionDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    super + %i[deposit deposit_invoice_id]
  end

  def transaction_created_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.transaction_created_at
    end
  end

  def deposit
    return h.middot if object.deposit.nil?
    h.link_to h.present_deposit(object.deposit), h.deposit_path(object.deposit.id)
  end

  def invoice_id
    h.link_to object.invoice_id, h.service_invoices_path(q: { invoice_id_eq: object.invoice_id })
  end
end
