# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BlockchainDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[key name height min_confirmations status explorer_transaction explorer_address]
  end
end
