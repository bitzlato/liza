class StatsMailer < ApplicationMailer

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
  end
end
