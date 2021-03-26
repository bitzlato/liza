class AccountsController < ApplicationController
  def index
    currency = Currency.find(params[:currency_id])
    accounts = Account
      .includes(:member)
      .where(currency_id: currency.id).order('created_at desc')
    render locals: {
      currency: currency,
      accounts: accounts,
      total_balance: accounts.sum(:balance),
      total_locked: accounts.sum(:locked)
    }
  end
end
