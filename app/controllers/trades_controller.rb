# frozen_string_literal: true

class TradesController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def index
    render locals: {
      trades: paginate(trades),
      member: member
    }
  end

  def show
    render locals: { trade: Trade.find(params[:id]) }
  end

  private

  def member
    Member.find params[:member_id] if params[:member_id].present?
  end

  def trades
    scope = Trade.includes(:market, :maker_order, :taker_order, :maker, :taker)
    scope = scope.by_member params[:member_id] if member.present?
    scope = scope.with_market currency.dependent_markets if currency.present?
    scope.order('created_at desc')
  end
end
