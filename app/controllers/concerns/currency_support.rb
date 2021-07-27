# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module CurrencySupport
  extend ActiveSupport::Concern

  included do
    helper_method :currency
  end

  private

  def currency
    currency_id = params.dig(:q, :currency_id_eq)
    Currency.find_by(id: currency_id) || raise(HumanizedError, "No such currency #{currency_id}") if currency_id.present?
  end
end
