class Book < ApplicationRecord
  belongs_to :author
  has_many :books_genres
  has_many :genres, through: :books_genres
  accepts_nested_attributes_for :author
  has_one_attached :cover

  validates :price, :inclusion => 1..1000

  def list_genres
    (self.genres.map { |genre| genre.name }).join(", ")
  end

  def can_edit?(user)
    return user && user.has_role?(:admin)
  end
end
