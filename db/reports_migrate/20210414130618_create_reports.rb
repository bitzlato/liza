class CreateReports < ActiveRecord::Migration[6.1]
  def change
    create_table :reports do |t|
      t.string :type, null: false
      t.integer :member_id, null: false
      t.jsonb :form, null: false, default: {}
      t.jsonb :results, null: false, default: {}
      t.string :status, null: false, default: 'pending'
      t.timestamp :processed_at

      t.timestamps
    end
  end
end
