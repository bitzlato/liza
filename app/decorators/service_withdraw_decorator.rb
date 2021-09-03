# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceWithdrawDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    super + %i[withdraw_member withdraw_state] - %i[updated_at] + %i[dump]
  end

  def date
    h.content_tag :span, class: 'text-nowrap' do
      I18n.l object.date
    end
  end

  def withdraw_id
    h.link_to object.withdraw_id, h.withdraw_path(object.withdraw_id)
  end

  def withdraw_state
    object.withdraw.try(:aasm_state)
  end

  def withdraw_member
    return h.middot unless object.withdraw.present?

    h.link_to h.member_path(object.withdraw.member) do
      object.withdraw.member.email
    end
  end
end
