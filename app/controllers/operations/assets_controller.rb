# frozen_string_literal: true

module Operations
  class AssetsController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def show
      render locals: { record: Operations::Asset.find(params[:id]) }
    end

    def index
      render locals: { assets: assets }
    end

    private

    def assets
      scope = Operations::Asset.includes(:account)
      scope = scope.where(currency_id: currency.id) if currency.present?
      scope.order('created_at desc')
    end
  end
end
