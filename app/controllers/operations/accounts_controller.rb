# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module Operations
  class AccountsController < ResourcesController
    include CurrencySupport

    layout 'fluid'

    def show
      render locals: { record: Operations::Account.find(params[:id]) }
    end

    def index
      render locals: { accounts: accounts }
    end

    private

    def accounts
      Operations::Account.order(:code)
    end
  end
end
