class BotsMetrics < Influxer::Metrics
  tags :currency_id
  attributes :amount

  validates :currency_id, :amount, presence: true

  scope :amount_changes, ->(group_by = '1d', fill = 'none') do
    select('LAST(balance) as balance, LAST(locked) as locked, LAST(amount) as amount')
      .time(group_by)
      .fill(fill)
      .group(:currency_id)
  end
end
