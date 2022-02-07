class WhalerTransfer < WhalerRecord
  self.table_name = :transfers

  scope :success, -> { where(state: 'successful') }

  def currency_id
    currency_code.downcase
  end

  def successful?
    state == 'successful'
  end

  def fail?
    state == 'failed'
  end
end
