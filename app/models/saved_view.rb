class SavedView < ApplicationRecord
  belongs_to :user
  belongs_to :list
  validates :name, presence: true

  # Safety: ensure we never persist a NULL query
  before_validation { self.query ||= {} }
end
