# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class PaymentAddressDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id address member currencies native_currency blockchain balances balances_updated_at]
  end

  def member
    h.link_to object.member.uid, h.member_path(object.member)
  end

  def wallet
    h.link_to object.wallet.name, h.wallet_path(object.wallet)
  end

  def currencies
    object.currencies.map(&:to_s).join(', ')
  end

  def balanced_updated_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.balanced_updated_at
    end
  end
end
