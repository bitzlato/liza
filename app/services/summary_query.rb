class SummaryQuery
  SUMMARY_MODELS = {
    Deposit               => { grouped_by: [:currency_id], aggregations: ['sum(amount)']},
    Withdraw              => { grouped_by: [:currency_id], aggregations: ['sum(amount)']},
    Account               => { grouped_by: [:currency_id], aggregations: ['sum(balance)','sum(locked)', :total]},
    Operations::Liability => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(credit)','sum(debit)', :total] },
    Operations::Revenue   => { grouped_by: [:currency_id], aggregations: ['sum(debit)', 'sum(credit)', :total] },
    Operations::Asset     => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(credit)', 'sum(debit)', :total] },
    Transaction           => { grouped_by: [:currency_id, :status], aggregations: ['sum(amount)'] },
  }

  def summary(scope)
    model_class = scope.model
    return unless SUMMARY_MODELS[model_class].present?
    meta = SUMMARY_MODELS[model_class]
    plucks = ((meta[:grouped_by]+meta[:aggregations]) - [:total]).map { |p| p.to_s.include?('(') ? p : [model_class.table_name,p].join('.') }
    rows = scope
      .group(*meta[:grouped_by])
      .reorder('')
      .order(meta[:grouped_by].first)
      .pluck(plucks.join(', '))
      .map { |row| prepare_row row, meta[:aggregations] }

    {
      grouped_by: meta[:grouped_by],
      aggregations: meta[:aggregations],
      rows: rows
    }
  end

  private

  def prepare_row(row, aggregations)
    return row unless aggregations.include? :total
    count = (aggregations - [:total]).count
    if aggregations.join.include? 'debit'
      total = row.last(2).first - row.last
    else
      total = row.slice(row.length - count, count).inject &:+
    end
    row + [total]
  end
end
