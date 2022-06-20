# frozen_string_literal: true

class AccountableFeeCalculator
  PEATIO_CLIENT_APPLICATION_ID = 2
  TRANSITION_DATE = '2022-06-01'.to_datetime

  def call
    peatio_fees = Transaction
                  .joins(:blockchain)
                  .accountable_fee
                  .where.not(blockchains: { key: 'solana-mainnet' })
                  .where('transactions.created_at < ?', TRANSITION_DATE)
                  .group(:fee_currency_id)
                  .sum(:fee)
    belomor_fees = BelomorBlockchainTransaction
                   .joins(:blockchain)
                   .accountable_fee
                   .where(client_application_id: PEATIO_CLIENT_APPLICATION_ID)
                   .where.not(blockchains: { key: 'solana-mainnet' })
                   .where('blockchain_transactions.created_at > ?', TRANSITION_DATE)
                   .group(:fee_currency_id)
                   .sum(:fee)
    solana_fees = Transaction
                  .joins(:blockchain)
                  .accountable_fee
                  .where(blockchains: { key: 'solana-mainnet' })
                  .group(:fee_currency_id)
                  .sum(:fee)
    peatio_fees.merge(belomor_fees, solana_fees) { |_key, old_value, new_value| old_value + new_value }
  end
end
