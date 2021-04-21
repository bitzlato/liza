class AddFileToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :file, :string
  end
end
