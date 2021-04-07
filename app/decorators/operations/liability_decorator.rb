module Operations
  class LiabilityDecorator < ApplicationDecorator
    delegate_all

    def self.table_columns
      [:member] + super
    end
  end
end
