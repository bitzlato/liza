# frozen_string_literal: true

class AccountableFeeCalculator
  PEATIO_CLIENT_APPLICATION_ID = 2

  def call(where = nil)
    scope = BelomorBlockchainTransaction
      .accountable_fee
      .where(client_application_id: PEATIO_CLIENT_APPLICATION_ID)
      .where(where)
      .group(:fee_currency_id)
      .sum(:fee)
  end
end
