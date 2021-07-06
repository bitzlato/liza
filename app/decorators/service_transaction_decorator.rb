# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceTransactionDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    super + %i[intention_id]
  end

  def intention_id
    if object.deposit.present?
      h.link_to object.intention_id, h.deposit_path(object.deposit.id)
    else
      object.intention_id
    end
  end
end
