# frozen_string_literal: true

class TransactionsController < ResourcesController
  include CurrencySupport
  layout 'fluid'
end
