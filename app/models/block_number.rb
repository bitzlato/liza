class BlockNumber < ApplicationRecord
  belongs_to :blockchain

  STATUSES = %w(pending processing success error)
end
