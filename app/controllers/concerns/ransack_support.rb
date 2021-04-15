module RansackSupport
  extend ActiveSupport::Concern
  included do
    helper_method :q
  end

  def index
    respond_to do |format|
      format.xlsx do

        raise HumanizedError, "Too many records" if records.count > Settings.max_export_records_count
        render locals: {
          records: records,
        }
      end
      format.html do
        render locals: {
          records: records,
          summary: SummaryQuery.new.summary(records.result),
          paginated_records: paginate(records)
        }
      end
    end
  end

  private

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
