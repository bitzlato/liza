# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module BlockchainExploring
  def explorer=(hash)
    write_attribute(:explorer_address, hash.fetch('address'))
    write_attribute(:explorer_transaction, hash.fetch('transaction'))
  end

  def explorer_url
    return if explorer_address.blank?
    u = URI(explore_address_url('fake'))
    u.scheme + '://' + u.host
  end

  def explore_address_url(address)
    explorer_address.to_s.gsub('#{address}', address)
  end

  def explore_transaction_url(txid)
    explorer_transaction.to_s.gsub('#{txid}', txid)
  end
end
