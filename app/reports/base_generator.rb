class BaseGenerator
  attr_reader :form, :report_name

  def initialize(form, report_name)
    @form = form
    @report_name = report_name
  end

  def perform
    raise 'implement'
  end

  def file
  end

  private

  def add_form_to_sheet(sheet)
    sheet.add_row [(form.time_from ? I18n.t(form.time_from, format: :short) : 'С начала'),
                   (form.time_from ? I18n.t(form.time_from, format: :short) : 'До момента формирования отчёта')]
    sheet.add_row [Member.model_name.human, form.member] if form.respond_to? :member
    sheet.add_row []
  end
end
