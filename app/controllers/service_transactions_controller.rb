# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ServiceTransactionsController < ResourcesController
  include CurrencySupport
  layout 'fluid'

  private

  def default_sort
    'transaction_created_at desc'
  end
end
