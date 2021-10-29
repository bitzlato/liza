# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class PaymentAddressDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id address member native_currency blockchain balances balances_updated_at fee_amount transactions_count collection_state collected_at gas_refueled_at
       last_transfer_try_at last_transfer_status enqueued_generation_at blockchain_approvals]
  end

  def collection_state
    h.collection_state_badge object.collection_state
  end

  def last_transfer_try_at
    present_time object.last_transfer_try_at
  end

  def collected_at
    present_time object.collected_at
  end

  def gas_refueled_at
    present_time object.gas_refueled_at
  end

  def balances_updated_at
    present_time object.balances_updated_at
  end

  def member
    h.link_to object.member.uid, h.member_path(object.member)
  end

  def wallet
    h.link_to object.wallet.name, h.wallet_path(object.wallet)
  end

  def address
    return h.middot if object.address.nil?

    h.link_to object.address, object.address_url, target: '_blank'
  end

  def currencies
    object.currencies.map(&:to_s).join(', ')
  end

  def balanced_updated_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.balanced_updated_at
    end
  end

  def blockchain_approvals
    BlockchainApproval.where(blockchain: object.blockchain, owner_address: object.address).as_json(only: %i[currency_id status txid created_at updated_at])
  end
end
