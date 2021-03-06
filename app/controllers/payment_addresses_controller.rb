# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class PaymentAddressesController < ResourcesController
  include CurrencySupport
  include BlockchainSupport
  layout 'fluid'

  private

  def index_form
    'index_form'
  end
end
