class WhalerTransfer < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :whaler
end
