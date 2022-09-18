class Post < ApplicationRecord
has_one_attached :image

def get_image
  unless image.attached?
    file_path = Rails.root.join('app/assets/images/no_image.jpg')
    image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
  end
    image
end

validates :title, presence: true

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

end
