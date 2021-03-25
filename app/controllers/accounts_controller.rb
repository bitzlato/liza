class AccountsController < ApplicationController
  def index
    accounts = Account
      .includes(:member)
      .where(currency_id: params[:currency_id]).order('created_at desc')
    render locals: {
      currency_id: params[:currency_id],
      accounts: accounts,
      total_balance: accounts.sum(:balance),
      total_locked: accounts.sum(:locked)
    }
  end
end
