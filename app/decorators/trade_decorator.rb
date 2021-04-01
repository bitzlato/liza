# frozen_string_literal: true

class TradeDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id market taker_type maker_order taker_order market amount price total maker taker]
  end

  def amount
    h.format_money object.amount, object.maker_order.currency, show_currency: true
  end

  def price
    h.format_money object.price, object.taker_order.currency, show_currency: true
  end

  def volume
    h.format_money object.volume, object.taker_order.currency, show_currency: true
  end

  def total
    h.format_money object.total, object.taker_order.currency, show_currency: true
  end

  def taker_order
    h.present_order object.taker_order
  end

  def maker_order
    h.present_order object.maker_order
  end

  def taker
    h.render 'member_brief', member: object.taker
  end

  def maker
    h.render 'member_brief', member: object.maker
  end
end
