class Report < ReportsRecord
  extend Enumerize

  belongs_to :member

  STATES = %[pending processing failed success]
  enumerize :state, in: STATES

  def results
     ActiveSupport::HashWithIndifferentAccess.new super
  end

  def form_object
    TimeRangeForm.new(form.symbolize_keys)
  end

  def perform!
    update status: :processing
    update results: reporter.perform, status: :success, processed_at: Time.zone.now
  end

  def reporter_class
    [self.class.name, 'Generator'].join('::').constantize
  end

  def reporter
    reporter_class.new(form_object)
  end
end
