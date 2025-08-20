class CreateLists < ActiveRecord::Migration[8.0]
  def change
    create_table :lists do |t|
      t.references :user, null: false, foreign_key: true
      t.string  :name,  null: false
      t.string  :color, null: false, default: "#4f6ef7"
      t.integer :position, null: false, default: 0
      t.timestamps

      # Indexes created atomically with table creation
      t.index [ :user_id, :position ]
      t.index [ :user_id, :name ], unique: true
    end
  end
end
