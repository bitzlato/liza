class AddErrorMessageToReports < ActiveRecord::Migration[6.1]
  def change
    add_column :reports, :error_message, :string
  end
end
