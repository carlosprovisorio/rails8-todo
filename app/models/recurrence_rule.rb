class RecurrenceRule < ApplicationRecord
  belongs_to :task

  validates :rule, presence: true
  validates :time_zone, presence: true

  def schedule
    IceCube::Schedule.from_hash(JSON.parse(rule))
  end

  def schedule=(icecube_schedule)
    self.rule = icecube_schedule.to_hash-to_json
  end
end
