# frozen_string_literal: true

class ReportsController < ApplicationController
  layout 'fluid'

  def new
    render locals: { form: form_class.new }
  end

  def create
    report = report_class.create!(
      member_id: current_user.id,
      form: form,
      results: reporter.perform
    )
    redirect_to report_path(report)
  end

  def index
    render locals: { paginated_records: paginate(records) }, layout: 'application'
  end

  def show
    report = Report.find params[:id]
    render locals: { report: report }
  end

  private

  def report_class
    controller_name.singularize.camelcase.constantize
  end

  def form
    @form ||= form_class.new params.fetch(:form, {}).permit!
  end

  def reporter
    @reporter ||= report_generator.new(form)
  end
end
