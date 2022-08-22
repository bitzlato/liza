# frozen_string_literal: true

class WalletLowBalanceCheckerWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  sidekiq_options queue: :reports

  BLOCKCHAIN_LIMITS = {
    'tron-mainnet' => {
      'usdt' => 10000
    },
    'bsc-mainnet' => {
      'usdt' => 5000
    }
  }

  LIMITS = {
    'usdt'  => 3000,
    'btc'   => 0.1,
    'bnb-bep20'   => 7,
    'ht-hrc20'    =>100,
    'matic' => 1500,
    'avax'  => 35,
  }

  BITZLATO_LIMITS = {
    'btc' => 0.15,
    'eth' => 1.2,
    'usdt' => 3000,
  }

  STATUS_FILE = Rails.root.join('./tmp/wallet_low_balances')

  TURNED_OFF = {
    'avax-mainnet' => ['usdc']
  }

  def perform
    current = {}
    messages = []
    BelomorWallet.joins(:client_application).where(client_applications: { key: 'peatio' }).active.each do |wallet|
      wallet.available_balances.each do |c, b|
        limit = BLOCKCHAIN_LIMITS.dig(wallet.blockchain.key, c) || LIMITS[c]
        next unless limit
        next if TURNED_OFF[wallet.blockchain.key]&.include?(c)

        if b.to_d < limit.to_d
          current['market'] ||= {}
          current['market'][wallet.id] ||= []
          current['market'][wallet.id] << c
        end

        saved_value = saved_low_balances.dig('market', wallet.id.to_s) || []

        if b.to_d < limit.to_d && !saved_value.include?(c)
          messages << ":exclamation: Низкий баланс кошелька (биржа): #{wallet.name} #{c.upcase}: #{b} < #{limit}"
        end

        if b.to_d >= limit.to_d && saved_value.include?(c)
          messages << ":white_check_mark: Баланс кошелька востановлен (биржа): #{wallet.name} #{c.upcase}: #{b} > #{limit}"
        end
      end
    end

    BitzlatoUser.market_user.wallets.each do |w|
      c = w.cc_code.downcase
      b = w.balance

      next unless BITZLATO_LIMITS[c]

      if b.to_d < BITZLATO_LIMITS[c].to_d
        current['bitzlato'] ||= {}
        current['bitzlato'][w.id] ||= []
        current['bitzlato'][w.id] << c
      end

      saved_value = saved_low_balances.dig('bitzlato', w.id.to_s) || []

      if b.to_d < BITZLATO_LIMITS[c].to_d && !saved_value.include?(c)
        messages << ":exclamation: Низкий баланс кошелька(p2p): <#{bitzlato_wallet_url(id: w.id)}> #{c.upcase}: #{b} < #{BITZLATO_LIMITS[c]}"
      end

      if b.to_d >= BITZLATO_LIMITS[c].to_d && saved_value.include?(c)
        messages << ":white_check_mark: Баланс кошелька востановлен(p2p): <#{bitzlato_wallet_url(id: w.id)}> #{c.upcase}: #{b} > #{BITZLATO_LIMITS[c]}"
      end
    end

    return if messages.blank?

    SlackNotifier.notifications.ping(messages.join("\n"))

    save_current_low_balances!(current)
  end

  private

  def save_current_low_balances!(data)
    File.write(STATUS_FILE, data.to_json)
  end

  def saved_low_balances
    if File.exist? STATUS_FILE
      JSON.parse(File.read(STATUS_FILE).strip.to_s)
    else
      {}
    end
  end

end
