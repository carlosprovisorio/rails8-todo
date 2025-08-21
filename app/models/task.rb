class Task < ApplicationRecord
  belongs_to :user
  belongs_to :list

  has_many :task_items, -> { order(position: :asc) }, dependent: :destroy
  has_many_attached :files

  has_one  :recurrence_rule, dependent: :destroy
  has_many :reminders, dependent: :destroy

  acts_as_taggable_on :tags

  enum :priority, { low: 0, normal: 1, high: 2, urgent: 3 }, prefix: true
  enum :status,   { todo: 0, doing: 1, done: 2, blocked: 3 },  prefix: true

  validates :title, presence: true, length: { maximum: 255 }
  validates :priority, presence: true
  validates :status, presence: true

  scope :active, -> { where(archived_at: nil) }
  scope :overdue, -> { where("due_at < ? AND archived_at IS NULL AND status <> ?", Time.current, statuses[:done]) }
  scope :due_today, -> {
    where(due_at: Time.current.beginning_of_day..Time.current.end_of_day, archived_at: nil)
  }

  before_save :set_completed_at

  private
  def set_completed_at
    if status_changed? && status_done?
      self.completed_at ||= Time.current
    elsif status_changed? && !status_done?
      self.completed_at = nil
    end
  end
end
