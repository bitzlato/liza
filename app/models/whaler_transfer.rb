class WhalerTransfer < WhalerRecord
  self.table_name = :transfers

  scope :success, -> { where(state: 'successful') }
end
