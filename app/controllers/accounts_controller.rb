# frozen_string_literal: true

class AccountsController < ApplicationController
  include CurrencySupport

  layout 'fluid'

  def show
    render locals: { account: Account.find(params[:id]) }
  end
end
