# frozen_string_literal: true

# Copyright (c) 2019 Danil Pismenny <danil@brandymint.ru>

class RenameMemberToAuthorInReports < ActiveRecord::Migration[6.1]
  def change
    rename_column :reports, :member_id, :author_id
    add_column :reports, :member_id, :integer
  end
end
