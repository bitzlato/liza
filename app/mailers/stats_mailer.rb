class StatsMailer < ApplicationMailer
  def daily(date = Date.current)
    emails = ENV.fetch('DAILY_STATS_EMAILS')

    # Member stat
    @new_users_count    = Member.where(created_at: date.all_day).count

    # Markets stat
    @markets            = Market.all

    trade_scope = Trade.where(created_at: date.all_day).group(:market_id)
    @total_trades_count = trade_scope.count
    @total_trade_users_count = trade_scope.user_trades.count
    @total_trade_bots_count = trade_scope.bot_trades.count

    # Currency stat
    @currencies         = Currency.all
    @total_deposit      = Deposit.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)
    @total_withdraw     = Withdraw.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)

    @date               = I18n.l(date, format: '%d %B %Y (%A)')

    mail(
      to: emails,
      from: ENV['SMTP_FROM'],
      subject: "Суточная статстика по бирже за #{@date}"
    )
  end
end
