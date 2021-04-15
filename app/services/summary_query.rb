class SummaryQuery
  SUMMARY_MODELS = {
    Deposit => { grouped_by: [:currency_id], aggregations: ['sum(amount)']},
    Withdraw => { grouped_by: ['withdraws.currency_id'], aggregations: ['sum(amount)']},
    Account => { grouped_by: [:currency_id], aggregations: ['sum(balance)','sum(locked)']},
    Operations::Liability => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(debit)','sum(credit)'] },
    Operations::Revenue => { grouped_by: [:currency_id], aggregations: ['sum(debit)', 'sum(credit)'] },
    Operations::Asset => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(debit)', 'sum(credit)'] }
  }

  def summary(scope)
    model_class = scope.model
    return unless SUMMARY_MODELS[model_class].present?
    meta = SUMMARY_MODELS[model_class]

    {
      grouped_by: meta[:grouped_by],
      aggregations: meta[:aggregations],
      rows: scope.group(*meta[:grouped_by]).reorder('').order(meta[:grouped_by].first).pluck((meta[:grouped_by]+meta[:aggregations]).join(', '))
    }
  end
end
