class Blockchain < ApplicationRecord
  has_many :wallets
  has_many :withdraws
  has_many :currencies
  has_many :payment_addresses
  has_many :transactions, through: :currencies
  has_many :deposits, through: :currencies

  def native_currency
    currencies.find { |c| c.parent_id.nil? } || raise("No native currency for wallet id #{id}")
  end

  def to_s
    key
  end

  def explore_address_url(address)
    return if address.nil?
    explorer_address.to_s.gsub('#{address}', address)
  end

  def explore_transaction_url(txid)
    return if address.txid?
    explorer_transaction.to_s.gsub('#{txid}', txid)
  end
end
