# frozen_string_literal: true

class BelomorDepositAddress < BelomorRecord
  self.table_name = 'deposit_addresses'

  enum kind: { deposit: 0, service: 1 }
end
