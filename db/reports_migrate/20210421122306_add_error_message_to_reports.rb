# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class AddErrorMessageToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :error_message, :string
  end
end
