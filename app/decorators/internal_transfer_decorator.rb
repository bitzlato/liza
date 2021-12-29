# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class InternalTransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id sender receiver currency amount state created_at updated_at]
  end
end
