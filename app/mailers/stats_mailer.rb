class StatsMailer < ApplicationMailer
  def daily(date = Date.current)
    emails = ENV.fetch('DAILY_STATS_EMAILS')

    # Member stat
    @new_users_count    = Member.where(created_at: date.all_day).count

    # Markets stat
    uids = ENV.fetch('STATS_EXCLUDE_MEMBER_UIDS').split(',')
    @markets            = Market.all
    @total_trades_count  = Trade.where(created_at: date.all_day).group(:market_id).count
    @total_trade_bots_count = Trade.joins(:maker, :taker)
                                   .where(created_at: date.all_day)
                                   .where(maker: {uid: uids}).or(Trade.where(taker: {uid: uids}))
                                   .group(:market_id).count
    # Currency stat
    @currencies         = Currency.all
    @total_deposit      = Deposit.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)
    @total_withdraw     = Withdraw.success.where(created_at: date.all_day).group(:currency_id).sum(:amount)

    @date               = date.to_s

    mail(to: emails, from: ENV['SMTP_FROM'], subject: "Суточная статстика по бирже за #{date.to_s}")
  end
end