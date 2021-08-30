# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BlockchainDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[key name height min_confirmations status explorer_transaction explorer_address client_options]
  end

  def client_options
    h.content_tag :span, object.client_options.as_json, class: 'text-small text-muted text-monospace'
  end
end
