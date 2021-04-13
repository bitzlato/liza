module Operations
  class ApplicationController < ::ApplicationController
    include CurrencySupport

    helper_method :account

    private

    def account
      account_id = params.dig(:q, :account_id_eq)
      return if account_id.nil?
      Operations::Account.find account_id
    end
  end
end
