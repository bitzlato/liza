require 'tempfile'

class MemberOrdersReport < Report
  def self.form_class
    MemberRecordsForm
  end

  def results
    super.merge(
      records: reporter.records,
      member: form_object.member_id.present? ? Member.find(form_object.member_id) : nil
    )
  end

  private

  class Generator < BaseGenerator
    def perform
      { records_count: records.count }
    end

    def records
      Order.ransack(q).result.includes(:currency)
    end

    def file
      @file ||= generate_file
    end

    private

    def generate_file
      columns = %i[id created_at member market type state ord_type price volume origin_volume origin_locked funds_received maker_fee taker_fee]
      xlsx_package = Axlsx::Package.new
      xlsx_package.workbook.add_worksheet(name: report_name) do |sheet|
        add_form_to_sheet sheet
        sheet.add_row columns
        records.each do |record|
          sheet.add_row columns.map { |c| record.send c }
        end
      end
      xlsx_package.use_shared_strings = true
      stream = xlsx_package.to_stream
      def stream.original_filename; "report.xlsx"; end
      stream
    end

    def q
      { member_id_eq: form.member_id, created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end
  end
end
