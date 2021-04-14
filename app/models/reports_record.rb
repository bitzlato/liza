class ReportsRecord < ApplicationRecord
  self.abstract_class = true
  connects_to database: { writing: :reports }
end
