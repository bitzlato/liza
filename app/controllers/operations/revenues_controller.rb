# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class RevenuesController < ResourcesController
    include CurrencySupport
    include RansackSupport

    layout 'fluid'

    # def index
    # render locals: {
    # revenues: paginate(revenues),
    # member: member,
    # totals: {
    # debit: revenues.sum(:debit),
    # credit: revenues.sum(:credit),
    # }
    # }
    # end

    def show
      render locals: { record: Operations::Revenue.find(params[:id]) }
    end
  end
end
