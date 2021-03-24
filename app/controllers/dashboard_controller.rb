class DashboardController < ApplicationController
  def index
    render locals: { liability_form: LiabilityReport::Form.new }
  end
end
