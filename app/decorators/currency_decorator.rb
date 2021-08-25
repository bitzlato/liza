# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CurrencyDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[
      id visible position name parent withdraw_limit_24h deposit_enabled
      withdrawal_enabled blockchain contract_address subunits precision
      min_deposit_amount min_withdraw_amount min_collection_amount withdraw_fee deposit_fee gas_limit gas_price
    ]
  end

  def id
    h.format_currency object
  end

  def blockchain
    h.content_tag :span, object.blockchain.key, class: 'text-nowrap'
  end
end
