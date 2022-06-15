# frozen_string_literal: true

class BelomorBlockchainTransaction < BelomorRecord
  self.table_name = 'blockchain_transactions'

  ADDRESS_KINDS = { unknown: 1, wallet: 2, deposit: 3, absence: 4 }.freeze

  enum from: ADDRESS_KINDS, _prefix: true

  belongs_to :blockchain, class_name: 'BelomorBlockchain'

  scope :accountable_fee, -> { where from: %i[wallet deposit] }
end
