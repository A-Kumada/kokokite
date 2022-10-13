class Post < ApplicationRecord
has_one_attached :image

validates :category_id, presence: true
validates :title, presence: true
validates :outline, presence: true
validates :necessaries, presence: true
validates :point, presence: true
validates :procedures, presence: true

validates :title, :necessaries,
    length: { maximum: 255 }

enum status: { public: 0, private: 1 }, _prefix: true

has_many :tagmaps, dependent: :destroy
has_many :tags, through: :tagmaps
belongs_to :user
belongs_to :category
has_many :comments, dependent: :destroy
has_many :favorites, dependent: :destroy
has_many :procedures, dependent: :destroy
accepts_nested_attributes_for :procedures, allow_destroy: true,reject_if: :content_present?

def content_present?(attributes)
    if attributes[:id].present?
      Procedure.find(attributes[:id]).destroy if attributes[:content] == nil
    end
end

def get_image(width, height)
  unless image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpeg')
    image.attach(io: File.open(file_path), filename: 'default-image.jpeg', content_type: 'image/jpeg')
  end
    image.variant(resize_to_limit: [width, height]).processed
end

def favorited_by?(user)
  favorites.exists?(user_id: user.id)
end

def self.search(search) #検索機能
  Post.where(['title LIKE ?', "%#{search}%"])
end

  def save_posts(tags)
   current_tags = self.tags.pluck(:tag_name) unless self.tags.nil?
   old_tags = current_tags - tags
   new_tags = tags - current_tags
   # Destroy
    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(tag_name:old_name)
    end

   # Create
    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(tag_name:new_name)
      self.tags << post_tag
    end

  end

end
