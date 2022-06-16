# frozen_string_literal: true

require 'whaler_client'

class BotsBalanceReport < Report
  def self.form_class
    BotsBalanceForm
  end

  class Generator < BaseGenerator
    def perform
      {
        dates: dates,
        currencies: currencies,
        totals: totals,
        records: records
      }
    end

    def records
      bots_metrics.as_json
                  .group_by { |hsh| hsh['time'] }
                  .transform_values { |group| group.index_by { |hsh| hsh['currency_id'] } }
    end

    def totals
      bots_metrics.as_json
                  .group_by { |hsh| hsh['time'] }
                  .transform_values { |arr| arr.sum { |hsh| hsh['amount'].to_d * currency_rates[hsh['currency_id']].to_d }.round(2) }
    end

    def dates
      records.keys
    end

    def currencies
      bots_metrics.as_json
                  .group_by { |hsh| hsh['currency_id'] }
                  .keys
    end

    private

    def currency_rates
      @current_rates ||= whaler_client.rates('USD').yield_self do |data|
        data['rates'].transform_keys!(&:downcase)
      end
    end

    def bots_metrics
      where =  if form.time_from.present? && form.time_to.present?
                 "time >= #{form.time_from}s AND time <= #{form.time_to}s"
               elsif form.time_from.present? && form.time_to.nil?
                "time >= #{form.time_from}s"
               elsif form.time_from.nil? && form.time_to.present?
                "time <= #{form.time_to}s"
               end
      BotsMetrics.where(where)
                 .amount_changes(form.group_by, 'previous')
    end

    def whaler_client
      @bz_public_client ||= WhalerClient.new(base_url: ENV.fetch('WHALER_API_URL'))
    end

  end
end
