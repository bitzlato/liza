# frozen_string_literal: true

class WalletLowBalanceCheckerWorker
  include Sidekiq::Worker
  include Rails.application.routes.url_helpers

  sidekiq_options queue: :reports

  LIMITS = {
    'usdt'  => 3000,
    'btc'   => 0.1,
    'bnb'   => 7,
    'ht'    =>100,
    'matic' => 1500,
    'avax'  => 35,
  }

  STATUS_FILE = Rails.root.join('./tmp/wallet_low_balances')

  def perform
    current = {}
    messages = []
    Wallet.hot.each do |w|
      w.available_balances.each do |c, b|
        next unless LIMITS[c]

        if b.to_d < LIMITS[c].to_d
          current[w.id] ||= []
          current[w.id] << c
        end

        if b.to_d < LIMITS[c].to_d && !saved_low_balances.fetch(w.id.to_s, []).include?(c)
          messages << ":exclamation: Низкий баланс кошелька(биржа): <#{wallet_url(id: w.id)}|#{w.name}> #{c.upcase}: #{b} < #{LIMITS[c]}"
        end

        if b.to_d >= LIMITS[c].to_d && saved_low_balances.fetch(w.id.to_s, []).include?(c)
          messages << ":white_check_mark: Баланс кошелька востановлен(биржа): <#{wallet_url(id: w.id)}|#{w.name}> #{c.upcase}: #{b} > #{LIMITS[c]}"
        end
      end
    end

    return if messages.blank?

    SlackNotifier.notifications.ping(messages.join("\n"))

    save_current_low_balances!(current)
  end

  def current_low_balances
    Wallet.hot.each_with_object({}) do |w, a|
      low_balances = w.available_balances.select { |c, b| LIMITS[c].present? && b.to_d < LIMITS[c].to_d }
      a[w.id] = low_balances if low_balances.any?
    end
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
