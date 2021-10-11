# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddFileToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :file, :string
  end
end
