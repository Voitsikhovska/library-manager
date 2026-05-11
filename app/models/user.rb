class User < ApplicationRecord
  has_secure_password
  has_many :books, dependent: :destroy
  has_many :authors, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false },
            format: { with: URI::MailTo::EMAIL_REGEXP }, length: { maximum: 255 }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  # Normalize email before validation
  before_validation :normalize_email

  def books_count
    books.count
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip if email.present?
  end
end
