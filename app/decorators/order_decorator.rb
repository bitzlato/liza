# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OrderDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at member market type state ord_type price volume origin_volume origin_locked funds_received
       maker_fee taker_fee]
  end

  def member
    h.render 'member_brief', member: object.member
  end

  def price
    h.order_price object
  end

  def volume
    h.format_money object.volume, object.volume_currency
  end

  def origin_volume
    h.format_money object.origin_volume, object.volume_currency
  end

  def origin_locked
    h.format_money object.origin_locked, object.volume_currency
  end

  def funds_received
    h.format_money object.funds_received, object.bid
  end

  def maker_fee
    h.present_fee object.maker_fee
  end

  def taker_fee
    h.present_fee object.taker_fee
  end

  def trades
    h.present_trades object.trades
  end
end
