# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class DashboardController < ResourcesController
  layout 'fluid'
  def index
    render locals: {
      accountable_fee: Transaction.accountable_fee.group(:fee_currency_id).sum(:fee),
      adjustments: Adjustment.accepted.group(:currency_id).sum(:amount)
    }
  end
end
