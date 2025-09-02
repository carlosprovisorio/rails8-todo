class List < ApplicationRecord
  belongs_to :user

  has_many :tasks, -> { order(position: :asc) }, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :color, format: { with: /\A#(?:\h{3}|\h{6})\z/i, message: "must be a hex color" }
end
