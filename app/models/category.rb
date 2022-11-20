class Category < ApplicationRecord
  validates :category_name, presence: true, length: { maximum: 255 }

  has_many :posts

end
