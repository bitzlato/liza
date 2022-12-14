# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

module MarketSupport
  extend ActiveSupport::Concern

  included do
    helper_method :market
  end

  private

  def market
    market_id = params.dig(:q, :market_id_eq)
    Market.find_by!(symbol: market_id) if market_id.present?
  end
end
