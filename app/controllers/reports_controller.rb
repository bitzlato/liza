class ReportsController < ApplicationController
  def create
    form = LiabilityReport::Form.new params[:liability_report_form].permit!
  end
end
