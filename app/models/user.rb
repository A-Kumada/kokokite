class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :nickname, :name_kana, :email,
    length: { maximum: 255 }
  validates :nickname,presence: true
  validates :name_kana,presence: true, 
  format: {
    with: /\A[\p{katakana}　ー－&&[^ -~｡-ﾟ]]+\z/,
    message: "全角カタカナのみで入力して下さい"
  }
  validates :email,presence: true
  validates :area,presence: true
  VALID_PASSWORD_REGEX = /\A[a-z0-9]+\z/i
  validates :password, format: { with: VALID_PASSWORD_REGEX }


  def self.guest
    find_or_create_by(email: 'guest@example.com' ) do |user|
      user.password = SecureRandom.urlsafe_base64
      user.nickname = "クマ"
      user.name_kana = "クマ"
      user.area = 1
    end
  end

  enum area: { "北海道": 0, "東北": 1, "関東": 2, "中部": 3, "近畿": 4, "中国": 5, "四国": 6, "九州": 7,"沖縄": 8 }

end