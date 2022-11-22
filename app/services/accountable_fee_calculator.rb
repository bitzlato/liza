# frozen_string_literal: true

class AccountableFeeCalculator
  PEATIO_CLIENT_APPLICATION_ID = 2

  def call(where = nil)
    subquery = BelomorBlockchainTransaction
               .accountable_fee
               .where(client_application_id: PEATIO_CLIENT_APPLICATION_ID)
               .where(where)
               .select('DISTINCT ON (txid) txid, *')
               .to_sql
    BelomorBlockchainTransaction.connection.exec_query("SELECT fee_currency_id, SUM(fee) FROM (#{subquery}) bt GROUP BY fee_currency_id;").rows.to_h
  end
end
