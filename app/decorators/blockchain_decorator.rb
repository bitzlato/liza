# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BlockchainDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[key name height client client_version min_confirmations status explorer_transaction explorer_address transactions_count block_numbers client_options disable_collection]
  end

  def transactions_count
    h.link_to object.transactions.count, h.transactions_path(q: { blockchain_id_eq: object.id })
  end

  def block_numbers
    return h.middot unless object.height > 1

    min, max, count = object.block_numbers_agg
    return h.middot if min.nil?

    buffer = []
    if max - min + 1 == count
      buffer << h.content_tag(:div, "#{min} - #{max}", class: 'text-nowrap text-monospace text-succcess')
    else
      buffer << h.content_tag(:div, "#{min} - #{max}", class: 'text-nowrap text-monospace text-danger')
      buffer << h.content_tag(:div, "Нехватка #{max - min + 1} блоков", class: 'text-small text-muted')
    end
    h.link_to h.block_numbers_path(q: { blockchain_id_eq: object.id }) do
      buffer.join.html_safe
    end
  end

  def key
    h.content_tag :span, object.key, class: 'text-nowrap text-monospace'
  end

  def height
    buffer = []
    buffer << h.content_tag(:div, object.height, class: 'text-nowrap text-monospace')
    buffer << h.content_tag(:div, present_time(object.height_updated_at), class: 'text-muted text-small')
    buffer.join.html_safe
  end

  def status
    h.blockchain_status object.status
  end

  def scan_latest_block
    return h.middot if object.scan_latest_block.nil?

    buffer = []
    buffer << h.link_to(h.content_tag(:div, object.scan_latest_block, title: blockchain.service.scan_host), object.explorer_url,
                        class: 'text-nowrap text-monospace', target: '_blank')
    buffer << h.difference_between_heights(object.height, object.scan_latest_block)
    buffer.join.html_safe
  end

  def client_options
    h.content_tag :span, object.client_options.as_json, class: 'text-small text-muted text-monospace'
  end
end
