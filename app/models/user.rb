class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  
  validates :nickname, :name_kana,
    length: { maximum: 255 }

  enum area: { "北海道": 0, "東北": 1, "関東": 2, "中部": 3, "近畿": 4, "中国": 5, "四国": 6, "九州": 7,"沖縄": 8 }

end
