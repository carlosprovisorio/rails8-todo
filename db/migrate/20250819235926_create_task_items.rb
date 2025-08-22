class CreateTaskItems < ActiveRecord::Migration[8.0]
  def change
    create_table :task_items do |t|
      t.references :task, null: false, foreign_key: true
      t.string  :title, null: false
      t.integer :position, null: false, default: 0
      t.datetime :completed_at
      t.timestamps

      t.index [ :task_id, :position ]
    end
  end
end
