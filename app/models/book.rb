class Book < ApplicationRecord
  belongs_to :user
  belongs_to :author

  validates :title, presence: true, length: { minimum: 1, maximum: 255 }
  validates :isbn, presence: true, uniqueness: true, format: { with: /\A[A-Z0-9\-]+\z/i, message: "only allows alphanumeric characters and dashes" }
  validates :published_year, numericality: { only_integer: true, allow_nil: true, greater_than_or_equal_to: 1000, less_than_or_equal_to: -> { Date.current.year } }
  validates :user_id, presence: true
  validates :author_id, presence: true
  validates :description, length: { maximum: 2000 }, allow_nil: true

  # Normalize ISBN before validation
  before_validation :normalize_isbn

  scope :by_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :by_author, ->(author_id) { where(author_id: author_id) }
  scope :by_year, ->(year) { where(published_year: year) }
  scope :by_year_range, ->(from, to) { where(published_year: from..to) }
  scope :recent, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(title: :asc) }
  scope :published_after, ->(year) { where("published_year >= ?", year) }
  scope :published_before, ->(year) { where("published_year <= ?", year) }

  def display_year
    published_year || 'Unknown'
  end

  def full_description
    "#{title} by #{author.name} (#{display_year})"
  end

  private

  def normalize_isbn
    self.isbn = isbn.to_s.upcase.strip if isbn.present?
  end
end
