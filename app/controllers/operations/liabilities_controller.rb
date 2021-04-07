# frozen_string_literal: true

module Operations
  class LiabilitiesController < ApplicationController
    include CurrencySupport

    layout 'fluid'

    def index
      render locals: { liabilities: paginate(liabilities) }
    end

    private

    def liabilities
      scope = Operations::Liability.includes(:member)
      scope = scope.where(currency_id: currency.id) if currency.present?
      scope.order('created_at desc')
    end
  end
end
