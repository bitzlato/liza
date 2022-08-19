# frozen_string_literal: true

class BelomorBlockchainTransaction < BelomorRecord
  self.table_name = 'blockchain_transactions'

  PEATIO_CLIENT_APP_ID = 2

  ADDRESS_KINDS = { unknown: 1, wallet: 2, deposit: 3, absence: 4 }.freeze

  enum from: ADDRESS_KINDS, _prefix: true

  belongs_to :blockchain, class_name: 'BelomorBlockchain'

  scope :accountable_fee, -> { where from: %i[wallet deposit] }

  scope :peatio, -> { where(client_application_id: PEATIO_CLIENT_APP_ID) }
end
