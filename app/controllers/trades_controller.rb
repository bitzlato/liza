# frozen_string_literal: true

class TradesController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def index
    render locals: {
      trades: trades
    }
  end

  def show
    render locals: { trade: Trade.find(params[:id]) }
  end

  private

  def trades
    scope = Trade.includes(:market, :maker_order, :taker_order, :maker, :taker)
    scope.order('created_at desc')
  end
end
