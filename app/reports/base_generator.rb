# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BaseGenerator
  Error = Class.new StandardError
  TooManyRecords = Class.new Error

  attr_reader :form, :report_name

  def initialize(form, report_name)
    @form = form
    @report_name = report_name
  end

  def perform
    raise 'implement'
  end

  def file; end

  def validate!
    raise TooManyRecords, "#{records.count} > #{Settings.max_export_records_count}" if records.count > Settings.max_export_records_count
  end

  private

  attr_reader :report_name

  def add_form_to_sheet(sheet)
    sheet.add_row [(form.time_from ? I18n.t(form.time_from, format: :short) : 'С начала'),
                   (form.time_from ? I18n.t(form.time_from, format: :short) : 'До момента формирования отчёта')]
    sheet.add_row [Member.model_name.human, form.member] if form.respond_to? :member
    sheet.add_row []
  end

  def dump_records(columns)
    xlsx_package = Axlsx::Package.new
    xlsx_package.workbook.add_worksheet(name: report_name) do |sheet|
      sheet.add_row columns
      records.each do |record|
        sheet.add_row columns.map { |c| record.send c }
      end
    end
    xlsx_package.use_shared_strings = true
    stream = xlsx_package.to_stream
    def original_filename() = 'report.xlsx'
    stream
  end
end
