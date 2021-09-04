# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class BlockNumbersController < ResourcesController
  include BlockchainSupport
  layout 'fluid'

  private

  def default_sort
    'number desc'
  end
end
