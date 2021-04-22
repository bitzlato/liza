# frozen_string_literal: true

# Liability report namespace
class LiabilityReport < Report
  class Generator < BaseGenerator

    def perform
      @currencies = Set.new
      @currency_type = :coin
      Operations::Asset.transaction do
        Operations::Liability.transaction do
          Operations::Revenue.transaction do
            Operations::Expense.transaction do
              platform_assets = fetch_records(:platform, :asset)
              platform_revenues = fetch_records(:platform, :revenue)
              member_liabilities = fetch_records(:member, :liability)
              {
                summary: {
                  platform_assets: platform_assets,
                  platform_revenues: platform_revenues,
                  member_liabilities: member_liabilities,
                  total_delta: { delta: delta(platform_assets[:delta], member_liabilities[:delta]) }
                },
                currencies: @currencies.sort
              }
            end
          end
        end
      end
    end

    private

    attr_reader :currency_type

    def delta(after, before)
      @currencies.each_with_object({}) do |currency, a|
        a[currency] = after[currency].to_d - before[currency].to_d
      end
    end

    def fetch_records(scope, record_type)
      accounts = Operations::Account.where(scope: scope, type: record_type)
      records_classes = accounts.map(&:records_class).uniq
      raise :wtf if records_classes.many?
      records_class = records_classes.first
      base_scope = records_class.where(account: accounts)
      before = summarize(previous_scope(base_scope))
      after = summarize(end_scope(base_scope))
      {
        before: before,
        after: after,
        delta: delta(after, before)
      }
    end

    def summarize(scope)
      scope.group(:currency_id).pluck('currency_id', Arel.sql('sum(credit) - sum(debit)')).each_with_object({}) do |record, a|
        currency_id, balance = record
        raise 'wtf' if a[currency_id].present?
        a[currency_id] = balance
        @currencies << currency_id
      end
    end

    def previous_scope(scope)
      return scope.none if form.time_from.nil?
      scope.where('created_at<?', form.time_from)
    end

    def framed_scope(scope)
      bs = form.time_from.nil? ? scope : scope.where('created_at>=?', form.time_from)
      bs = bs.where('created_at<?', form.time_to) unless form.time_to.nil?
      bs
    end

    def end_scope(scope)
      return scope if form.time_to.nil?
      scope.where('created_at<?', form.time_to)
    end
  end
end
