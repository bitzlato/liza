# frozen_string_literal: true

class AccountableFeeCalculator
  PEATIO_CLIENT_APPLICATION_ID = 2

  def call
    belomor_fees = BelomorBlockchainTransaction
                   .joins(:blockchain)
                   .accountable_fee
                   .where(client_application_id: PEATIO_CLIENT_APPLICATION_ID)
                   .where.not(blockchains: { key: 'solana-mainnet' })
                   .group(:fee_currency_id)
                   .sum(:fee)
    solana_fees = Transaction
                  .joins(:blockchain)
                  .accountable_fee
                  .where(blockchains: { key: 'solana-mainnet' })
                  .group(:fee_currency_id)
                  .sum(:fee)
    belomor_fees.merge(solana_fees) { |_key, old_value, new_value| old_value + new_value }
  end
end
