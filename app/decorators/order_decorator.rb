class OrderDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id created_at member market type state ord_type price volume origin_volume origin_locked funds_received maker_fee taker_fee trades]
  end

  def member
    h.render 'member_brief', member: object.member
  end

  def price
    h.format_money object.price, object.ask
  end

  def volume
    h.format_money object.volume, object.bid
  end

  def origin_volume
    h.format_money object.origin_volume, object.bid
  end

  def origin_locked
    h.format_money object.origin_locked, object.bid
  end

  def funds_received
    h.format_money object.funds_received, object.bid
  end

  def maker_fee
    h.format_money object.maker_fee, object.bid
  end

  def taker_fee
    h.format_money object.taker_fee, object.bid
  end

  def trades
    h.present_trades object.trades
  end
end
