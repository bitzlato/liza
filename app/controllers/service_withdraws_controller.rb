# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ServiceWithdrawsController < ResourcesController
  include CurrencySupport
  layout 'fluid'

  private

  def default_sort
    'date desc'
  end
end
