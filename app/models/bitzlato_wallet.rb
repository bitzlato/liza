class BitzlatoWallet < BitzlatoRecord
  self.table_name = 'wallet'

  def self.market_balances
    BitzlatoUser.market_user.wallets.group('cc_code').sum('balance + hold_balance').transform_keys(&:downcase)
  end
end
