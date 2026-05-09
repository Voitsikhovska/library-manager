class Author < ApplicationRecord
  has_many :books, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :birth_year, numericality: { only_integer: true, allow_nil: true }
end
