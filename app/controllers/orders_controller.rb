# frozen_string_literal: true

class OrdersController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def index
    render locals: {
      orders: orders
    }
  end

  def show
    render locals: { order: Order.find(params[:id]) }
  end

  private

  def orders
    scope = Order.includes(:member, :market, :ask_currency, :bid_currency)
    scope = scope.where(currency_id: currency.id) if currency.present?
    scope.order('created_at desc')
  end
end
