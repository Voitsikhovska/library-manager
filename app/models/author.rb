class Author < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :birth_year, numericality: { only_integer: true, allow_nil: true }

  scope :by_name, ->(name) { where("name ILIKE ?", "%#{name}%") }
  scope :by_birth_year, ->(year) { where(birth_year: year) }
  scope :by_birth_year_range, ->(from, to) { where(birth_year: from..to) }
  scope :alphabetical, -> { order(name: :asc) }
end
