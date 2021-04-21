class Report < ReportsRecord
  extend Enumerize

  belongs_to :author, class_name: 'Member'
  belongs_to :member, optional: true

  STATES = %[pending processing failed success]
  enumerize :state, in: STATES

  before_create do
    self.form ||= {}
  end

  before_save do
    self.member_id = form_object.try(:member_id)
  end

  after_commit :perform_async, on: :create

  def self.form_class
    TimeRangeForm
  end

  def results
     ActiveSupport::HashWithIndifferentAccess.new super
  end

  def records_count
    results[:records_count]
  end

  def form_object
    self.class.form_class.try :new, form.symbolize_keys
  end

  def perform_async
    ReporterWorker.perform_async id
  end

  def perform!
    update status: :processing
    update results: reporter.perform, status: :success, processed_at: Time.zone.now
  end

  def name
    self.class.model_name.human
  end

  def reporter_class
    [self.class.name, 'Generator'].join('::').constantize
  end

  def reporter
    reporter_class.new(form_object)
  end
end
