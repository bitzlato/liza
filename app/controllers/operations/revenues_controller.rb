# frozen_string_literal: true

module Operations
  class RevenuesController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def index
      render locals: { revenues: paginate(revenues) }
    end

    def show
      render locals: { record: Operations::Revenue.find(params[:id]) }
    end

    private

    def revenues
      scope = Operations::Revenue
      scope = scope.where(currency_id: currency.id) if currency.present?
      scope.order('created_at desc')
    end
  end
end
