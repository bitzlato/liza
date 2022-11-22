# frozen_string_literal: true

class BelomorBlockchain < BelomorRecord
  BTC_KEY = 'btc'

  self.table_name = 'blockchains'

  has_many :blockchain_currencies, class_name: 'BelomorBlockchainCurrency', foreign_key: 'blockchain_id', dependent: :destroy
  has_many :currencies, class_name: 'BelomorCurrency', through: :blockchain_currencies

  def balances
    key == BTC_KEY ? { 'btc' => balance } : nil
  end
end
