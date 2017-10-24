class PostEva < ApplicationRecord
  belongs_to :user
  belongs_to :post
  mount_uploader :eva_image, EvaImageUploader
end
