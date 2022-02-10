# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class CurrencyDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[
      id visible position name withdraw_limit_24h deposit_enabled
      withdrawal_enabled precision
      min_withdraw_amount min_collection_amount deposit_fee
    ]
  end

  def visible
    h.present_boolean object.visible
  end

  def withdrawal_enabled
    h.present_boolean object.withdrawal_enabled
  end

  def deposit_enabled
    h.present_boolean object.deposit_enabled
  end

  def name
    h.content_tag :span, object.name, class: 'text-nowrap'
  end

  def id
    h.format_currency object
  end
end
