class Author < ApplicationRecord
  belongs_to :user
  has_many :books, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { minimum: 2, maximum: 100 }
  validates :birth_year, numericality: { only_integer: true, allow_nil: true,
                                         greater_than_or_equal_to: 1000,
                                         less_than_or_equal_to: -> { Date.current.year } }
  validates :bio, length: { maximum: 5000 }, allow_nil: true

  # Normalize name before validation
  before_validation :normalize_name

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :by_birth_year, ->(year) { where(birth_year: year) }
  scope :by_birth_year_range, ->(from, to) { where(birth_year: from..to) }
  scope :alphabetical, -> { order(name: :asc) }
  scope :with_books, -> { joins(:books).distinct }
  scope :without_books, -> { left_joins(:books).where(books: { id: nil }) }

  def display_birth_year
    birth_year || "Unknown"
  end

  def books_count
    books.count
  end

  def age
    return nil unless birth_year
    Date.current.year - birth_year
  end

  private

  def normalize_name
    self.name = name.to_s.strip if name.present?
  end
end
