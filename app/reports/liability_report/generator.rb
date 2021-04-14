
# frozen_string_literal: true

# Liability report namespace
module LiabilityReport
  class Generator
    attr_reader :form

    def initialize(form)
      @form = form
      @currencies = Set.new
      @codes = Set.new
    end

    def perform
      previous = summarize(previous_scope)
      framed = summarize(framed_scope)

      {
        previous: previous,
        framed: framed,
        currencies: @currencies,
        codes: @codes
      }
    end

    private

    attr_reader :form

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
      return base_scope.none if form.time_from.empty?
      base_scope.where('created_at<?', form.time_from)
    end

    def framed_scope
      bs = form.time_from.empty? ? base_scope : base_scope.where('created_at>=?', form.time_from)
      bs = bs.where('created_at<?', form.time_to) unless form.time_to.empty?
      bs
    end

    def base_scope
      Operations::Liability
    end
  end
end
