# frozen_string_literal: true

class ReportsController < ApplicationController
  layout 'fluid'
  def new
    render locals: { liability_form: LiabilityReport::Form.new }
  end

  def create
    report = Report.create!(
      member_id: current_user.id,
      form: form,
      results: reporter.perform
    )
    redirect_to report_path(report)
  end

  def index
    render locals: { liability_form: form, paginated_records: paginate(records) }, layout: 'application'
  end

  # Withdraws and deposits
  def wd
  end

  private

  def form
    @form ||= LiabilityReport::Form.new params.fetch(:liability_report_form, {}).permit!
  end

  def reporter
    @reporter ||= LiabilityReport::Generator.new(form)
  end
end
