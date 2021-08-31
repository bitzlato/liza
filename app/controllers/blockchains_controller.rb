# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class BlockchainsController < ResourcesController
  layout 'fluid'

  private

  def default_sort
    'status desc, key desc'
  end
end
