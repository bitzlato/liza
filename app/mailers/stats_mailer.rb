class StatsMailer < ApplicationMailer
  def daily(date = Date.current)
    emails = ENV.fetch('DAILY_STATS_EMAILS')

    # Member stat
    @new_users_count    = Member.where(created_at: date.all_day).count

    # Markets stat
    @markets            = Market.all
    @total_trades_count  = Trade.where(created_at: date.all_day).group(:market_id).count

    # Currency stat
    @currencies         = Currency.all
    @total_deposit      = Deposit.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)
    @total_withdraw     = Withdraw.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)

    mail(to: emails, from: ENV['SMTP_FROM'], subject: "liza daily stats: #{date.to_s}")
  end
end
