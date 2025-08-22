class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true

      t.string  :title, null: false
      t.text    :notes
      t.datetime :due_at

      # enums (0=low,1=normal,2=high,3=urgent / 0=todo,1=doing,2=done,3=blocked)
      t.integer :priority, null: false, default: 1
      t.integer :status,   null: false, default: 0

      t.integer :position, null: false, default: 0
      t.datetime :completed_at
      t.datetime :archived_at

      t.timestamps

      # Helpful, query-friendly indexes
      t.index [ :user_id, :list_id, :position ]
      t.index :due_at
      t.index :status
      t.index :priority
      t.index :archived_at
      t.index [ :user_id, :status, :archived_at ]
    end
  end
end
