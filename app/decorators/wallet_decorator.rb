# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id updated_at name status kind address available_balances balance_updated_at enable_invoice fee_amount transactions_count]
  end

  def created_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.created_at
    end
  end

  def address
    h.link_to object.address, object.address_url, target: '_blank'
  end
end
