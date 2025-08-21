class Reminder < ApplicationRecord
  belongs_to :task

  validates :remind_at, presence: true
  validates :channel, inclusion: { in: %w[email] }
end
