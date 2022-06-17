# frozen_string_literal: true

require 'whaler_client'

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
    @current_rates = whaler_client.rates(TARGET_CURRENCY_RATE).yield_self do |data|
      data['rates'].transform_keys!(&:downcase)
      data
    end

    @revenue_scope = Operations::Revenue.where(created_at: period)

    # Количество активных пользователей
    @active_users_count = @revenue_scope.select(:member_id).distinct.count
    # Среднее количество операций на 1-го активного клиента
    @avg_trade_per_active_user = (@revenue_scope.count / @active_users_count.to_d).round(1)
    # Доходы биржи в разрезе операций (в usdt)
    @revenue_total_amount = @revenue_scope.group(:currency_id)
                                          .sum('credit - debit')
                                          .sum { |currency_id, amount| amount * @current_rates['rates'][currency_id].to_d }
    # Средняя доходность на 1-го активного клиента (usdt)
    @avg_revenue_per_active_user = (@revenue_total_amount / @active_users_count)

    # Member stat
    @new_users_count    = Member.where(created_at: period).count

    # Markets stat
    @markets            = Market.active
    @markets_map        = @markets.index_by(&:symbol)

    trade_scope = Trade.where(created_at: period, market: @markets).group(:market_id)
    @total_trades_count       = trade_scope.count
    @total_trade_users_volume = trade_scope.user_trades.sum(:amount)
    @total_trade_users_count  = trade_scope.user_trades.count
    @total_trade_bots_count   = trade_scope.bot_trades.count


    # Currency stat
    @currencies   = Currency.all
    @total_deposit  = Deposit.success.where(created_at: period).group(:currency_id).sum(:amount)
    @total_withdraw = Withdraw.success.where(created_at: period).group(:currency_id).sum(:amount)

    whaler_transfers_scope = WhalerTransfer.success.where(created_at: period)
    @total_whaler_transfers_count = whaler_transfers_scope.count
    @total_whaler_transfers_volume = whaler_transfers_scope.sum { |wt| wt.amount.to_d * @current_rates['rates'][wt.currency_id].to_d }

    @total_hot_wallets_balances = Wallet.hot_balances.sum do |c, b|
      b.to_d * @current_rates['rates'][c].to_d
    end
    @total_p2p_wallets_balances = BitzlatoWallet.market_balances.sum do |c, b|
      b.to_d * @current_rates['rates'][c].to_d
    end
    @total_deposits_balances = PaymentAddress.total_balances.sum {|c, v| v.to_d * @current_rates['rates'][c].to_d }

    # swaps
    swap_trade_scope = Trade.swap_trades.where(created_at: period, market: @markets)
    @total_swap_trades_count  = swap_trade_scope.count
    @total_swap_trades_volume = swap_trade_scope.group(:market_id).sum(:amount).sum do |market_id, amount|
      market = @markets_map[market_id]
      amount.to_d * @current_rates['rates'][market.base_unit].to_d
    end
  end

  private

  def whaler_client
    @bz_public_client ||= WhalerClient.new(base_url: ENV.fetch('WHALER_API_URL'))
  end
end
