# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class TransactionDecorator < ApplicationDecorator
  delegate_all

  def from_address
    [object.from_address, present_owner(address_owner(object.from_address))].join('<br>').html_safe
  end

  def to_address
    [object.to_address, present_owner(address_owner(object.to_address))].join('<br>').html_safe
  end

  private

  def address_owner(address)
    PaymentAddress.find_by(address: address) || Wallet.find_by(address: address)
  end

  def present_owner(address_owner)
    if address_owner.is_a? PaymentAddress
      h.present_payment_address(address_owner)
    elsif address_owner.is_a? Wallet
      h.present_wallet(address_owner)
    else
      "Unknown address_owner"
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
