# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ServiceWithdraw < ReportsRecord
  belongs_to :wallet
end
