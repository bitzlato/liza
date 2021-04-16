# frozen_string_literal: true

class ReportsController < ResourcesController
  layout 'fluid'

  helper_method :report_class

  def new
    render locals: { form: form_class.new }
  end

  def create
    report = report_class.create!(
     member_id: current_user.id,
     form: form
    )
    # report.async_perform
    redirect_to report_path(report)
  end

  def index
    if controller_name == 'reports'
      render locals: { paginated_records: paginate(records) }, layout: 'application'
    else
      redirect_to reports_path
    end
  end

  def show
    report = Report.find params[:id]
    render locals: { report: report }
  end

  private

  def model_class
    Report
  end

  def report_class
    controller_name.singularize.camelcase.constantize
  end

  def form_class
    TimeRangeForm
  end

  def form
    @form ||= form_class.new params.fetch(:form, {}).permit!
  end
end
