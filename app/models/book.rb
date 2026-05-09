class Book < ApplicationRecord
  belongs_to :user
  belongs_to :author

  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true
  validates :published_year, numericality: { only_integer: true, allow_nil: true }
  validates :user_id, presence: true
  validates :author_id, presence: true
end
