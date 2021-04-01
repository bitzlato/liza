# frozen_string_literal: true

module Operations
  class AccountsController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def index
      render locals: { accounts: accounts }
    end

    private

    def accounts
      Operations::Account.order(:code)
    end
  end
end
