class CreateRecurrenceRules < ActiveRecord::Migration[8.0]
  def change
    create_table :recurrence_rules do |t|
      t.references :task, null: false, foreign_key: true, index: { unique: true }

      t.text     :rule, null: false # JSON string of IceCube::Schedule.to_hash
      t.string   :time_zone, null: false, default: "America/Toronto"
      t.datetime :next_occurrence_at
      t.timestamps

      t.index :next_occurrence_at
    end
  end
end
