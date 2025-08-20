class CreateReminders < ActiveRecord::Migration[8.0]
  def change
    create_table :reminders do |t|
      t.references :task, null: false, foreign_key: true
      t.datetime :remind_at, null: false
      t.string   :channel, null: false, default: "email"
      t.datetime :delivered_at
      t.timestamps

      t.index [ :task_id, :remind_at ]
      t.index :delivered_at
    end
  end
end
