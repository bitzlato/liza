# frozen_string_literal: true

# Liability report namespace
class LiabilityReport < Report
  class Generator < BaseGenerator

    def initialize(form)
      super form
      @currencies = Set.new
      @codes = Set.new
    end

    def perform
      base_scope.transaction do
        previous = summarize(previous_scope)
        framed = summarize(framed_scope)
        ended = summarize(end_scope)
        {
          previous: previous,
          framed: framed,
          end: ended,
          currencies: @currencies,
          codes: @codes
        }
      end
    end

    private

    def summarize(scope)
      scope.group(:currency_id, :code).pluck('currency_id, code, sum(credit), sum(debit)').each_with_object({}) do |record, a|
        currency_id, code, credit, debit = record
        code = code.to_s
        a[code] ||= {}
        raise 'wtf' if a[code][currency_id].present?
        a[code][currency_id] = {credit: credit, debit: debit, balance: credit + debit}
        @currencies << currency_id
        @codes << code
      end
    end

    def previous_scope
      return base_scope.none if form.time_from.nil?
      base_scope.where('created_at<?', form.time_from)
    end

    def framed_scope
      bs = form.time_from.nil? ? base_scope : base_scope.where('created_at>=?', form.time_from)
      bs = bs.where('created_at<?', form.time_to) unless form.time_to.nil?
      bs
    end

    def end_scope
      return base_scope if form.time_to.nil?
      base_scope.where('created_at<?', form.time_to)
    end

    def base_scope
      Operations::Liability
    end
  end
end
