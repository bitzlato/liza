# frozen_string_literal: true

class AddressBalancesQuery
  def deposit_balances
    belomor_balances = BelomorDepositAddress
                       .connection
                       .execute("SELECT \"ckey\", sum(\"val\"::decimal) FROM deposit_addresses JOIN blockchains ON deposit_addresses.blockchain_id = blockchains.id, LATERAL jsonb_each_text(balances) AS each(CKEY,val) WHERE blockchains.key <> 'solana-mainnet' AND kind = 0 AND client_application_id = 2 GROUP BY \"ckey\"")
                       .each_with_object({}) { |r, a| a[r['ckey'].downcase] = r['sum'] }
    solana_balances = PaymentAddress
                      .connection
                      .execute("SELECT \"ckey\", sum(\"val\"::decimal) FROM payment_addresses JOIN blockchains ON payment_addresses.blockchain_id = blockchains.id, LATERAL jsonb_each_text(balances) AS each(CKEY,val) WHERE blockchains.key = 'solana-mainnet' GROUP BY \"ckey\"")
                      .each_with_object({}) { |r, a| a[r['ckey'].downcase] = r['sum'] }
    belomor_balances.merge(solana_balances) { |_key, old_value, new_value| old_value + new_value }
  end

  def service_balances
    belomor_balances = BelomorDepositAddress
                       .connection
                       .execute("SELECT \"ckey\", sum(\"val\"::decimal) FROM deposit_addresses JOIN blockchains ON deposit_addresses.blockchain_id = blockchains.id, LATERAL jsonb_each_text(balances) AS each(CKEY,val) WHERE blockchains.key <> 'solana-mainnet' AND kind = 1 AND client_application_id = 2 GROUP BY \"ckey\"")
                       .each_with_object({}) { |r, a| a[r['ckey'].downcase] = r['sum'] }
    solana_balances = Wallet.joins(:blockchain).where(blockchains: { key: 'solana-mainnet' }).each_with_object({}) { |w, a| w.available_balances.each_pair { |c, b| a[c] ||= 0.0; a[c] += b.to_d } }
    belomor_balances.merge(solana_balances) { |_key, old_value, new_value| old_value + new_value }
  end
end
