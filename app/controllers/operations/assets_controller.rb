# frozen_string_literal: true

module Operations
  class AssetsController < ResourcesController
    include CurrencySupport

    layout 'fluid'

    def show
      render locals: { record: Operations::Asset.find(params[:id]) }
    end
  end
end
