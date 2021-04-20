# frozen_string_literal: true

class ReportsController < ResourcesController
  layout 'fluid'

  def new
    render locals: { form: form, report_class: report_class, report_type: params[:report_type] }
  end

  def create
    if report_class.form_class.nil? || form.valid?
      report = report_class.create! member_id: current_user.id, form: form.nil? ? {} : form.as_json.except(*%w[validation_context errors])
      redirect_to report_path(report)
    else
      new
    end
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
    respond_to do |format|
      format.xlsx do
        response.headers['Content-Disposition'] = "attachment; filename=\"#{report.type}-#{report.id}.xlsx\""
        render report.type.underscore, locals: { report: report }
      end
      format.html do
        render locals: { report: report }
      end
    end
  end

  private

  def report_class
    (params[:report_type] || params.dig(:form, :report_type)).constantize
  end

  def form
    @form ||= report_class.form_class.new params.fetch(:form, {}).permit! if report_class.form_class.present?
  end

  def model_class
    Report
  end
end
