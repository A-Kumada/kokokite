class Post < ApplicationRecord
is_impressionable  #アクセスランキング用
has_one_attached :image

validates :category_id, presence: true
validates :title, presence: true, length: { maximum: 255 }
validates :outline, presence: true
validates :necessaries, presence: true, length: { maximum: 255 }
validates :point, presence: true
validates :procedures, presence: true

enum status: { public: 0, private: 1 }, _prefix: true #記事の公開・非公開用

belongs_to :user
belongs_to :category
has_many :post_tag_relations, dependent: :destroy
has_many :tags, through: :post_tag_relations, dependent: :destroy
has_many :comments, dependent: :destroy
has_many :favorites, dependent: :destroy
has_many :procedures, dependent: :destroy
has_many :impressions, foreign_key: :impressionable_id
accepts_nested_attributes_for :procedures, allow_destroy: true,reject_if: :content_present?

def content_present?(attributes) #手順
    if attributes[:id].present?
      Procedure.find(attributes[:id]).destroy if attributes[:content] == nil
    end
end

def get_image(width, height)
  unless image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    image.attach(io: File.open(file_path), filename: 'default-image.jpeg', content_type: 'image/jpeg')
  end
    image.variant(resize_to_limit: [width, height]).processed
end

def favorited_by?(user) #いいね機能
  favorites.exists?(user_id: user)
end

def self.search(search) #検索機能
  Post.where(['title LIKE ?', "%#{search}%"])
end

end
