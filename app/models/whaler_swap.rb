class WhalerSwap < WhalerRecord
  self.table_name = :swaps

  scope :done, -> { where(state: 'done') }

  def self.wallet_total_amount_for(cc_code)
    done.where(from_currency_code: cc_code).sum('from_amount + fee') -
      done.where(to_currency_code: cc_code).sum('to_amount')
  end
end
