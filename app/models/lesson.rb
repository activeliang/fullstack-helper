class Lesson < ApplicationRecord

  belongs_to :category
  has_many :posts, -> { order(weight: 'desc') },
    dependent: :destroy
  has_many :chapters, -> { order(weight: 'desc') },
    dependent: :destroy
  has_many :buyers
  mount_uploader :main_image, MainImageUploader
  mount_uploader :minor_image, MinorImageUploader

end
