# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DepositsController < ResourcesController
  include CurrencySupport
  include AasmStateSupport
  layout 'fluid'
end
