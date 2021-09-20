# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id name status kind address available_balances balances_by_transactions enable_invoice use_as_fee_source fee_amount currencies transactions_count]
  end

  def use_as_fee_source
    h.present_boolean object.use_as_fee_source
  end

  def enable_invoice
    h.present_boolean object.enable_invoice
  end

  def currencies
    h.render 'currency_wallets', currency_wallets: object.currency_wallets
  end

  def balance_updated_at
    return h.middot if object.balance_updated_at.nil?
    h.content_tag :span, class: 'text-nowrap', title: I18n.l(object.balance_updated_at) do
      h.time_ago_in_words object.balance_updated_at
    end
  end

  def balances_by_transactions
    buffer = h.render 'balances', balances: object.balances_by_transactions
    buffer << h.content_tag(:span, object.transactions.maximum(:updated_at), class: 'text-small text-muted')
    buffer
  end

  def available_balances
    buffer = h.render 'balances', balances: object.available_balances
    buffer << h.content_tag(:span, balance_updated_at, class: 'text-small text-muted')
    buffer
  end

  def created_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.created_at
    end
  end
end
