# frozen_string_literal: true

class BelomorBlockchain < BelomorRecord
  self.table_name = 'blockchains'

  has_many :blockchain_currencies, class_name: 'BelomorBlockchainCurrency', foreign_key: 'blockchain_id', dependent: :destroy
  has_many :currencies, class_name: 'BelomorCurrency', through: :blockchain_currencies
end
