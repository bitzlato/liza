# frozen_string_literal: true

class WhalerTransfersController < ResourcesController
  layout 'fluid'

  private

  def index_form
    'whaler_transfers_form'
  end
end
