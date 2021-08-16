# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class DepositDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id member created_at updated_at currency aasm_state collection_state amount fee txid txout tid transfer_type address invoice_id data]
  end

  def id
    h.content_tag :span, object.id, title: object.type
  end

  def data
    h.content_tag :span, 'data', title: object.data
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
