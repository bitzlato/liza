# frozen_string_literal: true

class AddressBalancesQuery
  def deposit_balances
    BelomorDepositAddress
      .connection
      .execute('SELECT "key", sum("val"::decimal) FROM deposit_addresses, LATERAL jsonb_each_text(balances) AS each(KEY,val) WHERE kind = 0 AND client_application_id = 2 GROUP BY "key"')
      .each_with_object({}) { |r, a| a[r['key'].downcase] = r['sum'] }
  end

  def service_balances
    BelomorDepositAddress
      .connection
      .execute('SELECT "key", sum("val"::decimal) FROM deposit_addresses, LATERAL jsonb_each_text(balances) AS each(KEY,val) WHERE kind = 1 AND client_application_id = 2 GROUP BY "key"')
      .each_with_object({}) { |r, a| a[r['key'].downcase] = r['sum'] }
  end
end
