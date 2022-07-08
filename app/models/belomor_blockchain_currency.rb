# frozen_string_literal: true

class BelomorBlockchainCurrency < BelomorRecord
  self.table_name = 'blockchain_currencies'

  belongs_to :currency, class_name: 'BelomorCurrency'
end
