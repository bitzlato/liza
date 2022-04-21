# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class AssetsController < ResourcesController
    include CurrencySupport

    def show
      render locals: { record: Operations::Asset.find(params[:id]) }
    end

    private

    def index_form
      'operation_form'
    end

  end
end
