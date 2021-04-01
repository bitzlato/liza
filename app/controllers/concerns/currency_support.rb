# frozen_string_literal: true

module CurrencySupport
  extend ActiveSupport::Concern

  included do
    helper_method :currency
  end

  private

  def currency
    Currency.find(params[:currency_id]) if params[:currency_id].present?
  end
end
