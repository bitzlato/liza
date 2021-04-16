# frozen_string_literal: true

class OrdersController < ResourcesController
  include CurrencySupport
  layout 'fluid'

  def show
    render locals: { order: Order.find(params[:id]) }
  end
end
