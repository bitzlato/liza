class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.integer :member_id, null: false
      t.jsonb :form, null: false, default: {}
      t.jsonb :results, null: false, default: {}
      t.string :status, null: false, default: 'pending'

      t.timestamps
    end
  end
end
