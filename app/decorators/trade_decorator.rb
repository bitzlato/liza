# frozen_string_literal: true

class TradeDecorator < ApplicationDecorator
  delegate_all


  delegate :maker_fee, to: :decorated_maker_order
  delegate :taker_fee, to: :decorated_taker_order

  def self.table_columns
    %i[created_at id market taker taker_type taker_order taker_fee taker_fee_amount maker maker_order maker_fee maker_fee_amount amount price total]
  end

  def amount
    h.format_money object.amount, object.maker_order.currency
  end

  def price
    h.format_money object.price, object.taker_order.currency
  end

  def volume
    h.format_money object.volume, object.taker_order.currency
  end

  def total
    h.format_money object.total, object.taker_order.currency
  end

  def maker_fee_amount
    h.format_money object.maker_fee_amount, object.taker_order.bid
  end

  def taker_fee_amount
    h.format_money object.taker_fee_amount, object.taker_order.ask
  end

  def decorated_taker_order
    @decorated_taker_order ||= OrderDecorator.decorate(object.taker_order)
  end

  def decorated_maker_order
    @decorated_maker_order ||= OrderDecorator.decorate(object.maker_order)
  end

  def taker
    decorated_taker_order.member
  end

  def maker
    decorated_maker_order.member
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
