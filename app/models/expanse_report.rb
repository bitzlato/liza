# frozen_string_literal: true

class ExpanseReport < Report
  def results
    super.merge(
      records: reporter.records
    )
  end

  class Generator < BaseGenerator
    def perform
      records
    end

    def records
      transaction_fees.map do |group, fee|
        { blockchain_name: group[0], currency: group[1], fee: fee }
      end
    end

    private

    def q
      { created_at_gt: form.time_from, created_at_lteq: form.time_to }
    end

    def transaction_fees
      BelomorBlockchainTransaction.accountable_fee
                                  .peatio
                                  .ransack(q)
                                  .result
                                  .joins(:blockchain)
                                  .group(:'blockchains.name', :fee_currency_id)
                                  .sum(:fee)
    end
  end
end
