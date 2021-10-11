# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class BlockNumber < PeatioRecord
  belongs_to :blockchain

  STATUSES = %w[pending processing success error]
end
