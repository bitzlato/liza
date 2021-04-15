class WdReportsController < ReportsController
  private

  def model_class
    raise :wtf
  end

  def form_class
    TimeRangeForm
  end

  def report_generator
    WdReport::Generator
  end
end
