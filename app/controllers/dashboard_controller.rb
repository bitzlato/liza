# frozen_string_literal: true

class DashboardController < ResourcesController
  layout 'fluid'
  def index
    render locals: { liability_form: LiabilityReport::Form.new }
  end
end
