class Task < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :list

  has_many :task_items, -> { order(position: :asc) }, dependent: :destroy
  has_many :reminders, dependent: :destroy
  has_one  :recurrence_rule, dependent: :destroy

  after_commit :materialize_next_if_completed, on: :update


  # Attachments
  has_many_attached :files

  # Tags
  acts_as_taggable_on :tags

  # Search (pg_search)
  include PgSearch::Model
  pg_search_scope :search_text,
    against: { title: "A", notes: "B" },
    associated_against: { tags: :name },
    using: {
      tsearch: { dictionary: "english", prefix: true, any_word: true },
      trigram: {}
    }

  # Enums
  enum :priority, { low: 0, normal: 1, high: 2, urgent: 3 }, prefix: true
  enum :status,   { todo: 0, doing: 1, done: 2, blocked: 3 },  prefix: true

  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :priority, presence: true
  validates :status, presence: true

  # Scopes
  scope :active, -> { where(archived_at: nil) }
  scope :overdue, -> {
    where("archived_at IS NULL AND status <> ? AND due_at < ?", statuses[:done], Time.current)
  }
  scope :due_today, -> {
    where(archived_at: nil, due_at: Time.current.beginning_of_day..Time.current.end_of_day)
  }
  scope :in_list, ->(list_id) { where(list_id:) }
  scope :by_priority, ->(dir = :desc) { order(priority: dir, due_at: :asc, created_at: :asc) }
  scope :recent, -> { order(created_at: :desc) }

  # Callbacks
  before_save :set_completed_at_timestamp

  # Instance helpers
  def completed?
    status_done? && completed_at.present?
  end

  def archived?
    archived_at.present?
  end

  private

  def materialize_next_if_completed
    return unless saved_change_to_status? && status_done?
    RecurrenceService.materialize_next!(self)
  end

  # Maintain completed_at based on status transitions.
  # In Rails 7.1+ use will_save_change_to_attribute? inside before_save.
  def set_completed_at_timestamp
    if will_save_change_to_status?
      if status_done?
        self.completed_at ||= Time.current
      else
        self.completed_at = nil
      end
    end
  end
end
