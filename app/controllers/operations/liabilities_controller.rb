# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class LiabilitiesController < ResourcesController
    include CurrencySupport
    layout 'fluid'
  end
end
