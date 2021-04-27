class Report < ReportsRecord
  extend Enumerize

  belongs_to :author, class_name: 'Member'
  belongs_to :member, optional: true

  mount_uploader :file, ReportFileUploader

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
  rescue => err
    Bugsnag.notify err do |b|
      b.meta_data = { report_id: id }
    end
    err
  end

  def form_object
    self.class.form_class.try :new, form.symbolize_keys
  end

  def perform_async
    ReporterWorker.perform_async id
  end

  def perform!
    with_lock do
      update status: :processing
      update results: reporter.perform, file: reporter.file, status: :success, processed_at: Time.zone.now, error_message: nil
    rescue => err
      Bugsnag.notify err do |b|
        b.meta_data = { report_id: id }
      end
      update status: :failed, error_message: [err.class.to_s, err.message].join('->')
    end
  end

  def name
    self.class.model_name.human
  end

  def reporter_class
    [self.class.name, 'Generator'].join('::').constantize
  end

  def reporter
    @reporter ||= reporter_class.new(form_object, [self.class.name, id].join('-'))
  end
end
