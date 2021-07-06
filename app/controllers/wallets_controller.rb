# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class WalletsController < ResourcesController
  layout 'fluid'

  def show
    redirect_to wallets_path(id: params[:id])
  end
end
