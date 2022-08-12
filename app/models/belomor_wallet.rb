# frozen_string_literal: true

class BelomorWallet < BelomorRecord
  self.table_name = 'wallets'

  belongs_to :blockchain, class_name: 'BelomorBlockchain'
  has_many :currency_wallets, class_name: 'BelomorCurrencyWallet', foreign_key: 'wallet_id'
  has_many :currencies, class_name: 'BelomorCurrency', through: :currency_wallets

  scope :active, -> { where(status: :active) }

  class << self
    def wallet_balances
      BelomorWallet.active.each_with_object({}) do |da, a|
        da.available_balances.each_pair do |c, b|
          a[c] ||= 0.0
          a[c] += b.to_d
        end
      end
    end
  end

  def available_balances
    (balances || {}).slice(*currencies.ids)
  end
end
