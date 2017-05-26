class ProductPhoto < ApplicationRecord
  belongs_to :product
  mount_uploader :product_image, ProductImageUploader
end
