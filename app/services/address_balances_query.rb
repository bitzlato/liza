# frozen_string_literal: true

class AddressBalancesQuery
  def deposit_balances
    BelomorDepositAddress
      .connection
      .execute('SELECT "key", sum("val"::decimal) FROM deposit_addresses, LATERAL jsonb_each_text(balances) AS each(KEY,val) WHERE client_application_id = 2 GROUP BY "key"')
      .each_with_object({}) { |r, a| a[r['key'].downcase] = r['sum'] }
  end

  def peatio_wallet_balances
    BelomorWallet
      .connection
      .execute('SELECT "key", sum("val"::decimal) FROM wallets, LATERAL jsonb_each_text(balances) AS each(KEY,val) WHERE client_application_id = 2 GROUP BY "key"')
      .each_with_object({}) { |r, a| a[r['key'].downcase] = r['sum'] }
  end
end
