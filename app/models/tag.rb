class Tag < ApplicationRecord
  has_many :tagmaps, dependent: :destroy
  has_many :post, through: :tagmaps
end
