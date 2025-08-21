class User < ApplicationRecord
  has_secure_password

  has_many :lists, dependent: :destroy
  has_many :tasks, dependent: :destroy

  # Validations
  NORMALIZED_EMAIL = /\A[^@\s]+@[^@\s]+\z/

  validates :email, presence: true, format: { with: NORMALIZED_EMAIL }, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }, allow_nil: true

  before_validation :downcase_email

  private

  def downcase_email
    self.email = email.to_s.downcase.strip
  end
end
