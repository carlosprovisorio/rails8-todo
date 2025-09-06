class SavedView < ApplicationRecord
  belongs_to :user
  belongs_to :list
  validates :name, presence: true
end
