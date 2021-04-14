class Reporter
  def initialize(date_from: , date_to: nil)
    @date_from = date_from
    @date_to = date_to
  end

  def perform
    {
      previous: summarize(previous_scope),
      framed: summarize(framed_scope)
    }
  end

  private

  attr_reader :date_from, :date_to

  def summarize(scope)
    scope.group(:currency_id, :code).pluck('currency_id, code, sum(credit), sum(debit)')
  end

  def previous_scope
    base_scope.where('created_at<?', date_from)
  end

  def framed_scope
    bs = base_scope.where('created_at>=?', date_from)
    bs = bs.where('created_at<?', date_to) unless date_to.nil?
    bs
  end

  def base_scope
    Operations::Liability
  end
end
