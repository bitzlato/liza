# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class TransactionDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id blockchain currency reference kind txid txout from_address from to_address to
    kind amount block_number status options fee accountable_fee created_at updated_at
    is_followed]
  end

  def to
    h.present_address_kind object.to
  end

  def from
    h.present_address_kind object.from
  end

  def status
    h.transaction_status object.status
  end

  def kind
    h.present_kind object.kind
  end

  private

  def address_owner(address)
    PaymentAddress.find_by_address(address) || Wallet.find_by_address(address)
  end

  def present_owner(address_owner)
    case address_owner
    when PaymentAddress
      h.present_payment_address(address_owner)
    when Wallet
      h.present_wallet(address_owner)
    else
      'Unknown address_owner'
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
