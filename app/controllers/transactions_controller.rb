# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class TransactionsController < ResourcesController
  include CurrencySupport
  include BlockchainSupport
  layout 'fluid'

  private

  def default_sort
    'block_number desc'
  end
end
