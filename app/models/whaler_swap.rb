class WhalerSwap < WhalerRecord
  self.table_name = :swaps

  def self.wallet_total_amount_for(cc_code)
    where(from_currency_code: cc_code).sum('from_amount + fee') -
      where(to_currency_code: cc_code).sum('to_amount')
  end
end
