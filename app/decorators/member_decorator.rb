# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

class MemberDecorator < ApplicationDecorator
  ACCOUNT_PREFIX = 'account_'
  delegate_all

  def self.table_columns
    %i[uid created_at email level state role group username] + Currency.visible.order(:id).pluck(:id).map do |cur|
                                                                 ACCOUNT_PREFIX + cur
                                                               end
  end

  def self.table_th_class(column)
    return 'text-right' if column.start_with? ACCOUNT_PREFIX

    super
  end

  def account(currency)
    currency = Currency.find_by(id: currency)
    account = member.get_account(currency)
    return h.middot if account.nil?

    h.render 'account_brief', account: account
  end

  def method_missing(meth, *args, &block)
    if meth.to_s.start_with? ACCOUNT_PREFIX
      account(meth.to_s.gsub(ACCOUNT_PREFIX, ''))
    else
      super
    end
  end
end
