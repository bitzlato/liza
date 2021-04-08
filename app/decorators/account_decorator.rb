# frozen_string_literal: true

class AccountDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member currency created_at amount balance locked total_deposit_amount total_withdraw_amount total_sell total_buy total_paid total_revenue trade_income trades estimated_amount]
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

  def total_withdraw_amoount
    h.format_money object.total_withdraw_amoount, object.currency
  end

  def total_deposit_amount
    h.format_money object.total_deposit_amount, object.currency
  end

  def locked
    h.format_money object.locked, object.currency
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
