class WdReport < Report
  class Generator < BaseGenerator
    def perform
      q = { created_at_gt: form.time_from, created_at_lteq: form.time_to }
      deposits = SummaryQuery.new.summary(Deposit.ransack(q).result)
      withdraws = SummaryQuery.new.summary(Withdraw.ransack(q).result)
      currencies = Set.new
      rows = {}
      deposits[:rows].each do |row|
        currencies << row.first
        rows[row.first] ||= {}
        rows[row.first][:deposited] = row.second
      end
      deposits[:rows].each do |row|
        currencies << row.first
        rows[row.first] ||= {}
        rows[row.first][:withdrawn] = row.second
      end
      return { rows: rows, currencies: currencies }
    end
  end
end
