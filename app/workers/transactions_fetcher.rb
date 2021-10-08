# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Fetch service transactions and store it in local database
#
class TransactionsFetcher
  include Sidekiq::Worker

  sidekiq_options queue: :transactions_fetcher

  def perform
    return unless Rails.env.production?

    Wallet.active.standalone.find_each do |wallet|
      perform_wallet wallet
    end
  end

  def perform_wallet(wallet)
    @wallet = wallet
    @client = build_client wallet
    begin
      fetch_payments
    rescue StandardError
      Faraday::TimeoutError
    end
    begin
      fetch_vouchers
    rescue StandardError
      Faraday::TimeoutError
    end
    begin
      fetch_invoices
    rescue StandardError
      Faraday::TimeoutError
    end
    begin
      fetch_transactions
    rescue StandardError
      Faraday::TimeoutError
    end
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
      client_provided_id = payment['clientProvidedId']
      raise "Fetch payment has no clientProvidedId (#{payment})" if client_provided_id.nil?

      withdraw = client_provided_id.to_s.start_with?('TID') ? Withdraw.find_by(tid: client_provided_id) : Withdraw.find_by(id: client_provided_id)
      attrs = {
        status: payment['status'],
        date: parse_time(payment['date']),
        public_name: payment['publicName'],
        currency_id: payment['cryptocurrency'].downcase,
        withdraw_type: payment['type'],
        amount: payment['amount'],
        dump: payment
      }
      sw = ServiceWithdraw.create_with(attrs).find_or_create_by!(wallet_id: @wallet.id, withdraw_id: withdraw.id)
      sw.assign_attributes attrs
      sw.save! if sw.changed?
    end
    # Ignore bugsnag for timeout errors
  rescue Faraday::TimeoutError => e
    Rails.logger.error e
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

  def fetch_transactions
    client
      .get('/api/gate/v1/invoices/transactions/')['data']
      .each do |transaction|
      attrs = {
        currency_id: transaction['cryptocurrency'].downcase,
        amount: transaction['amount'].to_d,
        username: transaction['username'],
        telegram_id: transaction['telegramId'],
        transaction_created_at: parse_time(transaction['createdAt'])
      }
      ServiceTransaction.create_with(attrs).find_or_create_by!(wallet_id: @wallet.id, invoice_id: transaction['invoiceId'])
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
