class WdReport < Report
  class Generator < BaseGenerator
    def perform
      @currencies = Set.new
      @rows = {}
      @keys = Set.new
      add_rows build_query(Deposit), :deposits
      add_rows build_query(Withdraw), :withdraws
      add_rows operations(Deposit, Operations::Asset), :deposit_to_operations_assets
      add_rows operations(Withdraw, Operations::Asset), :withdraws_to_operations_assets
      add_rows operations(Deposit, Operations::Liability), :deposit_to_operations_liabilities
      add_rows operations(Withdraw, Operations::Liability), :withdraws_to_operations_liabilities
      return { rows: @rows, currencies: @currencies, keys: @keys }
    end

    private

    def add_rows(records, key)
      @keys << key
      records.each do |record|
        currency_id, amount = record
        @currencies << currency_id
        @rows[currency_id] ||= {}
        @rows[currency_id][key] = amount
      end
    end

    def q
      { created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def operations(reference_type, klass)
      klass
        .ransack(q)
        .result
        .where(reference_type: reference_type.name)
        .group(:currency_id)
        .pluck(:currency_id, Arel.sql('sum(credit)-sum(debit)'))
    end

    def build_query(scope)
      scope
        .ransack(q.merge completed: true)
        .result
        .group(:currency_id)
        .sum(:amount)
    end
  end
end
