module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q
  end

  def index
    render locals: {
      records: records,
      summary: summary,
      paginated_records: paginate(records)
    }
  end

  private

  def summary
     records.group(:currency_id).reorder('').pluck('currency_id, sum(amount)')
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
    q.result.includes(model_class.reflections.select { |k, r| r.is_a? ActiveRecord::Reflection::BelongsToReflection }.keys)
  end
end
