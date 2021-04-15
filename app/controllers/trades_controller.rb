# frozen_string_literal: true

class TradesController < ApplicationController
  layout 'fluid'

  def show
    render locals: { trade: Trade.find(params[:id]) }
  end
end
