# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# Summary query for different models
#
class SummaryQuery
  RANSAK_COLUMN_MAPPING = {
    'operations_accounts.description' => 'account_description'
  }
  SUMMARY_MODELS = {
    Deposit => { grouped_by: %i[currency_id blockchain_id aasm_state], aggregations: ['sum(amount)', 'sum(fee)'] },
    Withdraw => { grouped_by: %i[currency_id blockchain_id aasm_state], aggregations: ['sum(amount)', 'sum(sum)', 'sum(fee)'] },
    Account => { grouped_by: [:currency_id], aggregations: ['sum(balance)', 'sum(locked)', :total] },
    Operations::Liability => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(credit)', 'sum(debit)', :total] },
    Operations::Revenue => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(credit)', 'sum(debit)', :total] },
    Operations::Asset => { grouped_by: [:currency_id, 'operations_accounts.description'], aggregations: ['sum(credit)', 'sum(debit)', :total] },
    Transaction => { grouped_by: %i[currency_id blockchain_id status], aggregations: ['sum(amount)', 'sum(fee)'] },
    ServiceWithdraw => { grouped_by: %i[currency_id status], aggregations: ['sum(amount)'] },
    ServiceInvoice => { grouped_by: %i[currency_id status], aggregations: ['sum(amount)'] },
    ServiceTransaction => { grouped_by: %i[currency_id], aggregations: ['sum(service_transactions.amount)'] },
    WhalerTransfer => { grouped_by: %i[currency_code state], aggregations: ['sum(amount)'] },
    MemberTransfer => { grouped_by: %i[currency_id service], aggregations: ['sum(amount)'] }
  }.freeze

  # rubocop:disable Metrics/MethodLength
  def summary(scope)
    model_class = scope.model
    return unless SUMMARY_MODELS[model_class].present?

    meta = SUMMARY_MODELS[model_class]

    plucks = ((meta[:grouped_by] + meta[:aggregations]) - [:total]).map do |p|
      p.to_s.include?('(') || p.to_s.include?('.') ? p : [model_class.table_name, p].join('.')
    end
    rows = scope
           .group(*meta[:grouped_by])
           .reorder('')
           .order(meta[:grouped_by].first)

    # hide records with merged currencies
    if model_class.column_names.include?('currency_id')
      rows = rows.where.not(currency: Currency.hidden)
    elsif model_class.column_names.include?('currency_code')
      rows = rows.where.not(currency_code: Currency.hidden.pluck(:cc_code))
    end

    rows = rows.pluck(plucks.join(', ')).map { |row| prepare_row row, meta[:aggregations] }

    {
      grouped_by: meta[:grouped_by].map { |col| RANSAK_COLUMN_MAPPING[col] || col },
      aggregations: meta[:aggregations].map { |col| RANSAK_COLUMN_MAPPING[col] || col },
      rows: rows
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def prepare_row(row, aggregations)
    return row unless aggregations.include? :total

    count = (aggregations - [:total]).count
    total = if aggregations.join.include? 'debit'
              row.last(2).first - row.last
            else
              row.slice(row.length - count, count).inject(&:+)
            end
    row + [total]
  end
end
