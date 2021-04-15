module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q
  end

  SUMMARY_MODELS = {
    Deposit => { grouped_by: [:currency_id], aggregations: ['sum(amount)']},
    Withdraw => { grouped_by: [:currency_id], aggregations: ['sum(amount)']},
    Account => { grouped_by: [:currency_id], aggregations: ['sum(balance)','sum(locked)']},
    Operations::Liability => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(debit)','sum(credit)'] },
    Operations::Revenue => { grouped_by: [:currency_id], aggregations: ['sum(debit)', 'sum(credit)'] }
  }

  def index
    render locals: {
      records: records,
      summary: summary,
      paginated_records: paginate(records)
    }
  end

  private

  def summary
    return unless SUMMARY_MODELS[model_class].present?
    meta = SUMMARY_MODELS[model_class]

    {
      grouped_by: meta[:grouped_by],
      aggregations: meta[:aggregations],
      rows: records.group(*meta[:grouped_by]).reorder('').pluck((meta[:grouped_by]+meta[:aggregations]).join(', '))
    }
  end

  def q
    @q ||= build_q
  end

  def build_q
    qq = model_class.ransack(params[:q])
    qq.sorts = 'created_at desc' if qq.sorts.empty?
    qq
  end

  def records
    q.result.includes(model_class.reflections.select { |k, r| r.is_a?(ActiveRecord::Reflection::BelongsToReflection) && !r.options[:polymorphic] }.keys)
  end
end
