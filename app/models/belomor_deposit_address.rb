# frozen_string_literal: true

class BelomorDepositAddress < BelomorRecord
  self.table_name = 'deposit_addresses'

  enum kind: { deposit: 0, service: 1 }
  enum service_kind: { fee: 200, hot: 310, warm: 320, cold: 330, standalone: 400 }

  belongs_to :blockchain, class_name: 'BelomorBlockchain'

  scope :active, -> { where(archived_at: nil) }

  class << self
    def service_balances
      BelomorDepositAddress.service.each_with_object({}) do |da, a|
        da.available_balances.each_pair do |c, b|
          a[c] ||= 0.0
          a[c] += b.to_d
        end
      end
    end
  end

  def available_balances
    (balances || {}).slice(*blockchain.currencies.ids)
  end
end
