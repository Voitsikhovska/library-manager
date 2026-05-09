class Book < ApplicationRecord
  belongs_to :user
  belongs_to :author

  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :published_year, numericality: { only_integer: true, allow_nil: true }
  validates :user_id, presence: true
  validates :author_id, presence: true

  scope :by_title, ->(title) { where("title ILIKE ?", "%#{title}%") }
  scope :by_author, ->(author_id) { where(author_id: author_id) }
  scope :by_year, ->(year) { where(published_year: year) }
  scope :by_year_range, ->(from, to) { where(published_year: from..to) }
  scope :recent, -> { order(created_at: :desc) }
  scope :alphabetical, -> { order(title: :asc) }
end
