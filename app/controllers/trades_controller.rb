# frozen_string_literal: true

class TradesController < ResourcesController
  layout 'fluid'

  def show
    render locals: { trade: Trade.find(params[:id]) }
  end
end
