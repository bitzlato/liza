# frozen_string_literal: true

class BelomorDepositAddress < BelomorRecord
  self.table_name = 'deposit_addresses'

  enum kind: { deposit: 0 }

  belongs_to :blockchain, class_name: 'BelomorBlockchain'

  scope :active, -> { where(archived_at: nil) }
end
