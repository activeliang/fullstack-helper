class Subproduct < ApplicationRecord

  belongs_to :product
  mount_uploader :subproduct_image, SubproductImageUploader
end
