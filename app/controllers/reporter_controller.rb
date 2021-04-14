class ReporterController < ApplicationController
  layout 'fluid'
  def show
    render locals: { liability_form: LiabilityReport::Form.new }
  end

  def create
  end
end
