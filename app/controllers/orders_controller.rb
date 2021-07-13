# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class OrdersController < ResourcesController
  include MarketSupport
  layout 'fluid'

  def show
    render locals: { order: Order.find(params[:id]) }
  end
end
