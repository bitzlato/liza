# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class ReportsRecord < ApplicationRecord
  self.abstract_class = true
  connects_to database: { writing: :reports }
end
