# frozen_string_literal: true

class BlockchainCurrency < PeatioRecord
  belongs_to :blockchain
  belongs_to :currency
end
