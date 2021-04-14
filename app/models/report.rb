class Report < ReportsRecord
  extend Enumerize

  STATES = %[pending processing failed success]
  enumerize :state, in: STATES

  def results
     ActiveSupport::HashWithIndifferentAccess.new super
  end

  def form_object
    LiabilityReport::Form.new(form.symbolize_keys)
  end
end
