# frozen_string_literal: true

class BelomorCurrency < BelomorRecord
  self.table_name = 'currencies'

  # NOTE: type column reserved for STI
  self.inheritance_column = nil
end
