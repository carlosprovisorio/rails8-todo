class TaskItem < ApplicationRecord
  belongs_to :task
  validates :title, presence: true, length: { maximum: 255 }

  def completed?
    completed_at.present?
  end
end
