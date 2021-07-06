# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ServiceInvoicesController < ResourcesController
  include CurrencySupport
  layout 'fluid'
end
