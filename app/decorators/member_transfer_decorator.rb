# frozen_string_literal: true

class MemberTransferDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[id key description member_uid member amount currency service meta created_at updated_at]
  end
end
