# frozen_string_literal: true

module Operations
  class AssetsController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def index
      render locals: { assets: assets }
    end

    private

    def assets
      scope = Operations::Asset
      scope = scope.where(currency_id: currency.id) if currency.present?
      scope.order('created_at desc')
    end
  end
end
