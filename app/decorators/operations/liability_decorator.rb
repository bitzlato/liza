# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

module Operations
  class LiabilityDecorator < ApplicationDecorator
    delegate_all

    def self.table_columns
      [:member] + super
    end
  end
end
