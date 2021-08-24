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

  def options
    h.content_tag :span, object.options.as_json, class: 'text-small text-muted text-monospace'
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
    h.link_to object.blockchain.explore_address_url(object.from_address), target: '_blank', cass: 'text-monospace' do
      h.present_address object.from_address
    end
  end

  def blockchain
    h.link_to h.blockchain_url(object.blockchain) do
      h.content_tag :span, object.blockchain.key, class: 'text-nowrap text-monospace'
    end
  end

  def address
    return h.middot if object.address.nil?
    h.link_to object.blockchain.explore_address_url(object.address), target: '_blank', class: 'text-monospace' do
      h.present_address object.address
    end
  end

  def to_address
    return h.middot if object.to_address.nil?
    h.link_to object.blockchain.explore_address_url(object.to_address), target: '_blank', class: 'text-monospace' do
      h.present_address object.to_address
    end
  end

  def rid
    return h.middot unless object.rid?

    h.link_to object.rid, object.blockchain.explore_address_url(object.rid), target: '_blank', class: 'text-monospace'
  end

  def txid
    present_txid object.txid
  end

  def txid_with_recorded_transaction(txid)
    return h.middot unless txid?
    link = present_txid(txid)
    buffer = if object.recorded_transaction.present?
      h.link_to('tx in db #'+object.recorded_transaction.id.to_s, h.transaction_path(object.recorded_transaction.id), class: 'badge badge-primary')
    else
      h.content_tag :span, 'not found in db', class: 'badge badge-warning'
    end
    link << h.content_tag( :div, buffer )
    link
  end

  def reference
    return h.middot if object.reference_id.nil?
    h.link_to object.reference, h.url_for(object.reference)
  end

  private

  def present_txid(txid)
    return h.middot if txid.nil?
    h.link_to txid, object.transaction_url, target: '_blank', class: 'text-monospace'
  end

end
