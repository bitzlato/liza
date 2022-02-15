# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class BitzlatoWalletsController < ResourcesController
  layout 'fluid'

  private

  def model_class
    BitzlatoUser.market_user.wallets
  end

  def default_sort
    'balance desc'
  end
end
