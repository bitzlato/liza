# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class ApplicationDecorator < Draper::Decorator
  TEXT_RIGHT = %i[fee debit balance credit amount locked total price volume origin_volume origin_locked funds_received maker_fee
                  total_deposit_amount total_withdraw_amount estimated_amount divergence total_sell total_buy
                  taker_fee].freeze

  def self.table_columns
    object_class.attribute_names.map(&:to_sym)
  end

  def self.table_th_class(column)
    return 'text-right' if TEXT_RIGHT.include? column
  end

  def self.table_td_class(column)
    table_th_class column
  end

  def self.table_tr_class(record); end

  def self.attributes
    table_columns
  end

  def currency
    h.format_currency object.currency
  end

  def member
    h.render 'member_brief', member: object.member
  end

  def data
    h.content_tag :code, object.data.as_json, class: 'text-small'
  end

  def updated_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.updated_at
    end
  end

  def created_at
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.created_at
    end
  end

  def from_address
    h.link_to object.blockchain.explore_address_url(object.from_address), target: '_blank' do
      h.present_address object.from_address
    end
  end

  def blockchain
    h.link_to h.blockchain_url(object.blockchain) do
      h.content_tag :span, object.blockchain.key, class: 'text-nowrap'
    end
  end

  def to_address
    return h.middot if object.to_address.nil?
    h.link_to object.blockchain.explore_address_url(object.to_address), target: '_blank' do
      h.present_address object.to_address
    end
  end

  def txid
    h.link_to object.txid, object.transaction_url, target: '_blank', class: 'text-monospace'
  end

  def reference
    return h.middot if object.reference_id.nil?
    h.link_to object.reference, h.url_for(object.reference)
  end

end
