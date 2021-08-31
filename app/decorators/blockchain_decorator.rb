# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BlockchainDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[key name height height_updated_at client client_version min_confirmations status explorer_transaction explorer_address client_options]
  end

  def height_updated_at
    present_time object.height_updated_at
  end

  def status
    h.blockchain_status object.status
  end

  def client_options
    h.content_tag :span, object.client_options.as_json, class: 'text-small text-muted text-monospace'
  end
end
