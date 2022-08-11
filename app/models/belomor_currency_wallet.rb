# frozen_string_literal: true

class BelomorCurrencyWallet < BelomorRecord
  self.table_name = 'currencies_wallets'

  belongs_to :currency, class_name: 'BelomorCurrency'
  belongs_to :wallet, class_name: 'BelomorWallet'
end
