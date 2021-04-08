# frozen_string_literal: true

class AccountsController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def index
    render locals: {
      accounts: paginate(accounts),
      totals: {
        total_balance: accounts.sum(:balance),
        total_locked: accounts.sum(:locked),
      }
    }
  end

  def show
    render locals: { account: Account.find(params[:id]) }
  end

  private

  def accounts
    scope = Account.includes(:member)
    scope = scope.where(currency_id: currency.id) if currency.present?
    scope.order('created_at desc')
  end
end
