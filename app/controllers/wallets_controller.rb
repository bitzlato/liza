# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class WalletsController < ResourcesController
  include BlockchainSupport
  layout 'fluid'
end
