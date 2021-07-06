# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Fetch service transactions and store it in local database
#
class TransactionsFetcher
  include Sidekiq::Worker

  sidekiq_options queue: :transactions_fetcher

  def perform
    Wallet.active.standalone.find_each do |wallet|
      perform_wallet wallet
    end
  end

  def perform_wallet(wallet)
    @wallet = wallet
    @client = build_client wallet
    fetch_payments
    fetch_vouchers
    fetch_invoices
  end

  private

  attr_reader :client

  # Withdraws with direct payments
  #
  # rubocop:disable Metrics/MethodLength
  def fetch_payments
    client
      .get('/api/gate/v1/payments/list/')
      .each do |payment|
      withdraw_id = payment['clientProvidedId'].to_i
      raise "Fetch payment has no clientProvidedId (#{payment})" if withdraw_id.zero?

      attrs = {
        status: payment['status'],
        date: parse_time(payment['date']),
        public_name: payment['publicName'],
        currency_id: payment['cryptocurrency'].downcase,
        withdraw_type: payment['type'],
        amount: payment['amount']
      }
      sw = ServiceWithdraw.create_with(attrs).find_or_create_by!(wallet_id: @wallet.id, withdraw_id: withdraw_id)
      sw.assign_attributes attrs
      sw.save! if sw.changed?
    end
  end
  # rubocop:enable Metrics/MethodLength

  # Withdraws by vouchers
  #
  def fetch_vouchers
    client.get('/api/p2p/vouchers/')['data'].each do |voucher|
      raise 'not implmented' if voucher.present?
    end
    # w.withdraw_id = voucher['deepLinkCode']
    # w.is_done = voucher['status'] == 'cashed'
    # w.amount = voucher.dig('cryptocurrency', 'amount').to_d
    # w.currency = voucher.dig('cryptocurrency', 'code').downcase
  end

  # Invoices
  def fetch_transactions
    client
      .get('/api/gate/v1/invoices/transactions/')['data']
      .each do |transaction|
      # {
      # "telegramId": null,
      # "username": "danil_brandy",
      # "amount": "0.01",
      # "cryptocurrency": "BTC",
      # "createdAt": 1622456228298,
      # "invoiceId": 21442
      # }
      ServiceInvoice
        .create_with(
          currency_id: transaction['cryptocurrency'].downcase,
          username: transaction['username'],
          amount: transaction['amount'].to_d
        ).find_or_create_by!(wallet_id: @wallet.id, invoice_id: transaction['invoiceId'])
      # {
      # address: transaction['username'],
      # id: generate_id(transaction['invoiceId']),
      # amount: transaction['amount'].to_d,
      # currency: transaction['cryptocurrency']
      # }
    end
  end

  def fetch_invoices
    client
      .get('/api/gate/v1/invoices/')['data']
      .each do |invoice|
      attrs = {
        currency_id: invoice['cryptocurrency'].downcase,
        amount: invoice['amount'].to_d,
        comment: invoice['comment'],
        status: invoice['status'],
        completed_at: parse_time(invoice['completedAt']),
        expiry_at: parse_time(invoice['expiryAt']),
        invoice_created_at: parse_time(invoice['createdAt'])
      }

      si = ServiceInvoice.create_with(attrs).find_or_create_by!(wallet_id: @wallet.id, invoice_id: invoice['id'])
      si.assign_attributes attrs
      si.save! if si.changed?
    end
  end

  def parse_time(time)
    return nil if time.nil?

    Time.at(time / 1000)
  end

  def build_client(wallet)
    Bitzlato::Client
      .new(home_url: ENV.fetch('BITZLATO_API_URL', wallet.fetch(:uri)),
           key: ENV.fetch('BITZLATO_API_KEY', wallet.fetch(:key)).yield_self { |key| key.is_a?(String) ? JSON.parse(key) : key }.transform_keys(&:to_sym),
           uid: ENV.fetch('BITZLATO_API_CLIENT_UID', wallet.fetch(:uid)).to_i,
           logger: ENV.true?('BITZLATO_API_LOGGER'))
  end
end
