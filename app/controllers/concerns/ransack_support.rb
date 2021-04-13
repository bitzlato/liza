module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q
  end

  def index
    render locals: { records: records, paginated_records: paginate(records) }
  end

  private

  def q
    @q ||= model_class.ransack(params[:q])
  end

  def model_class
    self.class.name.remove('Controller').singularize.constantize
  end

  def records
    q.result.includes(model_class.reflections.select { |k, r| r.is_a? ActiveRecord::Reflection::BelongsToReflection }.keys)
  end
end
