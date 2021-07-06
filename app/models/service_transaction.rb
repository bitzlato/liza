# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceTransaction < ReportsRecord
  belongs_to :invoice, class_name: 'ServiceInvoice', primary_key: :invoice_id

  def deposit
    @deposit ||= Deposit.find_by(intention_id: intention_id)
  end

  def wallet
    @wallet ||= Wallet.find wallet_id
  end

  def intention_id
    uid = ENV.fetch('BITZLATO_API_CLIENT_UID', wallet.fetch(:uid)).to_i
    [uid, invoice_id].join(':')
  end
end
