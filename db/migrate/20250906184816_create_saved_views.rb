class CreateSavedViews < ActiveRecord::Migration[8.0]
  def change
    create_table :saved_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :list, null: false, foreign_key: true
      t.string :name, null: false
      t.jsonb :query, null: false, default: {}
      t.index [ :user_id, :list_id, :name ], unique: true

      t.timestamps
    end
  end
end
