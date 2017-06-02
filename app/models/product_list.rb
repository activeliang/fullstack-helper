class ProductList < ApplicationRecord
  belongs_to :order
  mount_uploader :lists_image, ListsImageUploader

end
