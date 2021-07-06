# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceWithdraw < ReportsRecord
  def withdraw
    @withdraw ||= Withdraw.find_by(id: withdraw_id)
  end
end
