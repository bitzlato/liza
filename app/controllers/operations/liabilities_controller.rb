# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class LiabilitiesController < ResourcesController
    include CurrencySupport
    layout 'fluid'

    private

    def index_form
      'operation_form'
    end
  end
end
