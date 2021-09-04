# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceWithdraw < ReportsRecord
  def withdraw
    @withdraw ||= withdraw_id.to_s.start_with?('TID') ? Withdraw.find_by(tid: withdraw_id) : Withdraw.find_by(id: withdraw_id)
  end
end
