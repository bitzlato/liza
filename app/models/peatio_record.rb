# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class PeatioRecord < ApplicationRecord
  self.abstract_class = true
  connects_to database: { reading: :peatio, writing: :peatio }
end
