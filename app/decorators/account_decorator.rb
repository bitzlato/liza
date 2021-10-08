# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member currency created_at amount balance locked total_deposit_amount total_withdraw_amount total_sell total_buy total_paid total_revenue
       locked_checks
       trade_income]
  end

  def self.attributes
    %i[id member currency created_at amount balance locked total_deposit_amount total_withdraw_amount total_sell total_buy total_paid total_revenue
       trade_income trades trades_fee estimated_amount]
  end

  def locked_checks
    result = AccountLocksChecker.new(object).perform
    if result.fetch(:locked_equal)
      h.content_tag :span, 'Сходится', class: 'badge badge-success'
    else
      buffer = []
      buffer << h.content_tag(:span, 'НЕ Сходится', class: 'badge badge-danger')
      buffer << h.content_tag(:code, result, class: 'text-small text-muted')
    end
  end

  def trades_fee
    h.format_money object.trades_fee, object.currency
  end

  def amount
    h.format_money object.amount, object.currency
  end

  def divergence
    h.format_divergence object.divergence, object.currency
  end

  def balance
    h.format_money object.balance, object.currency
  end

  def total_buy
    h.format_money object.total_buy, object.currency
  end

  def total_sell
    h.format_money object.total_sell, object.currency
  end

  def total_revenue
    h.format_money object.total_revenue, object.currency
  end

  def total_paid
    h.format_money object.total_paid, object.currency
  end

  def trade_income
    h.format_money object.trade_income, object.currency
  end

  def estimated_amount
    if object.divergence.zero?
      h.format_money object.estimated_amount, object.currency
    else
      h.format_money(object.estimated_amount, object.currency) +
        h.content_tag(:div, class: 'text-small') do
          ('Расхождение: ' + h.format_money(object.divergence, object.currency, css_class: 'text-warning', tooltip: 'Должно быть 0')).html_safe
        end
    end
  end

  def total_withdraw_amount
    h.format_money object.total_withdraw_amount, object.currency
  end

  def total_deposit_amount
    h.format_money object.total_deposit_amount, object.currency
  end

  def locked
    h.link_to h.operations_liabilities_path(q: { member_id_eq: object.member_id,
                                                 account_id_eq: Operations::Account.find_by(kind: :locked, scope: :member,
                                                                                            currency_type: object.currency.type) }) do
      h.format_money object.locked, object.currency
    end
  end

  def trades
    if object.trades.empty?
      h.content_tag :span, class: 'text-muted' do
        I18n.t 'helpers.no_trades'
      end
    else
      h.link_to h.trades_path(member_id: object.member_id) do
        I18n.t 'helpers.trades', count: object.trades.count
      end
    end
  end
end
