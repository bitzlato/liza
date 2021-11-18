class StatsMailer < ApplicationMailer
  def daily(date = Date.current)
    emails = ENV.fetch('DAILY_STATS_EMAILS')

    # Member stat
    @new_users_count    = Member.where(created_at: date.all_day).count

    # Markets stat
    uids = ENV.fetch('STATS_EXCLUDE_MEMBER_UIDS').split(',')
    member_ids          = Member.where(uid: uids).ids
    @markets            = Market.all
    @total_trades_count = Trade.where(created_at: date.all_day).group(:market_id).count

    trade = Trade.where(created_at: date.all_day)

    @total_trades_user_and_user = trade.where.not(maker_id: member_ids)
                                       .where.not(taker_id: member_ids)
                                       .group(:market_id).count
    @total_trades_bot_and_user = trade.where("(maker_id IN (:member_ids) AND taker_id NOT IN (:member_ids)) OR (maker_id NOT IN (:member_ids) AND taker_id IN (:member_ids))", member_ids: member_ids)
                                      .group(:market_id).count
    @total_trades_bot_and_bot = trade.where(maker_id: member_ids, taker_id: member_ids)
                                     .group(:market_id).count

    @total_users_trade = Trade.where.not(maker_id: member_ids).where.not(taker_id: member_ids).group(:market_id).count

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
