class TimeRangeForm
  include ActiveModel::Model

  attr_accessor :time_from, :time_to

  def time_from=(value)
    value = parse_time value if value.is_a? String
    @time_from = value
  end

  def time_to=(value)
    value = parse_time value if value.is_a? String
    @time_to = value
  end

  private

  def parse_time(value)
    return value if value.is_a?(Time) || value.is_a?(Date)
    return nil if value.blank?
    Time.parse value
  end
end
