# frozen_string_literal: true

class AccountsController < ResourcesController
  include CurrencySupport

  layout 'fluid'

  def show
    render locals: { account: Account.find(params[:id]) }
  end
end
