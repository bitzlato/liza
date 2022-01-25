# frozen_string_literal: true

require 'bz_public_client'

class StatsMailer < ApplicationMailer
  TARGET_CURRENCY_RATE = 'USD'

  def daily(date: Date.current, emails: ENV.fetch('DAILY_STATS_EMAILS'))
    init_stat_for_period(date.all_day)

    @date   = I18n.l(date, format: '%d %B %Y (%A)')
    @title  = "Статистика за #{@date}"

    mail(
      to: emails,
      from: ENV['SMTP_FROM'],
      subject: "Суточная статстика по бирже за #{@date}",
      template_name: 'stat_period'
    )
  end

  def monthly(date: Date.current, emails: ENV.fetch('DAILY_STATS_EMAILS'))
    init_stat_for_period(date.all_month)

    @start_date = I18n.l(date.beginning_of_month, format: '%d %B %Y (%a)')
    @end_date   = I18n.l(date.end_of_month, format: '%d %B %Y (%a)')
    @title      = "Статистика c #{@start_date} по #{@end_date}"

    mail(
      to: emails,
      from: ENV['SMTP_FROM'],
      subject: "Месячная статстика по бирже c #{@start_date} по #{@end_date}",
      template_name: 'stat_period'
    )
  end

  private

  def init_stat_for_period(period)
    # Member stat
    @new_users_count    = Member.where(created_at: period).count

    # Markets stat
    @markets            = Market.all

    trade_scope = Trade.where(created_at: period).group(:market_id)
    @total_trades_count       = trade_scope.count
    @total_trade_users_volume = trade_scope.user_trades.sum(:amount)
    @total_trade_users_count  = trade_scope.user_trades.count
    @total_trade_bots_count   = trade_scope.bot_trades.count

    # Currency stat
    @currencies   = Currency.all
    @total_deposit  = Deposit.success.where(created_at: period).group(:currency_id).sum(:amount)
    @total_withdraw = Withdraw.success.where(created_at: period).group(:currency_id).sum(:amount)

    @current_rates = bz_public_client.rates(TARGET_CURRENCY_RATE).yield_self do |data|
      data['rates'].transform_keys!(&:downcase)
      data
    end

    @total_hot_wallets_balances = Wallet.hot.each_with_object({}) do |w, a|
      w.available_balances.each_pair { |c, b| a[c] ||= 0.0; a[c] += b.to_d * @current_rates['rates'][c].to_d }
    end.values.sum
    @total_deposits_balances = PaymentAddress.total_balances.sum {|c, v| v.to_d * @current_rates['rates'][c].to_d }
  end

  private

  def bz_public_client
    @bz_public_client ||= BzPublicClient.new(base_url: ENV.fetch('BITZLATO_API_URL'))
  end
end
