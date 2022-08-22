# frozen_string_literal: true

class SummaryReport < Report
  class Generator < BaseGenerator
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def perform
      total = revenues.merge(expanses) do |currency_id, rev, exp|
        rev - exp
      end

      {
        records_count: revenues.count + expanses.count,
        currencies: total.keys,
        revenues: revenues,
        expanses: expanses,
        total: total,
      }
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    def q
      { created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def revenues
      Operations::Revenue.ransack(q).result.group(:currency_id).sum("credit - debit")
    end

    def expanses
      BelomorBlockchainTransaction.accountable_fee
                                  .peatio
                                  .ransack(q)
                                  .result
                                  .group(:fee_currency_id)
                                  .sum(:fee)
    end

  end
end
