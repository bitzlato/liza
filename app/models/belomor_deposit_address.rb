# frozen_string_literal: true

class BelomorDepositAddress < BelomorRecord
  self.table_name = 'deposit_addresses'

  enum kind: { deposit: 0, service: 1 }
  enum service_kind: { fee: 200, hot: 310, warm: 320, cold: 330, standalone: 400 }

  belongs_to :blockchain, class_name: 'BelomorBlockchain'

  scope :active, -> { where(archived_at: nil) }

  def available_balances
    (balances || {}).slice(*blockchain.currencies.ids)
  end
end
