# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class WalletDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id updated_at name status kind address available_balances balance_updated_at enable_invoice]
  end

  def address
    [h.link_to(object.address, object.address_url, target: '_blank'), present_owner(address_owner(object.address))].join('<br>').html_safe
  end
end
