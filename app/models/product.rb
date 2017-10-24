class Product < ApplicationRecord
  belongs_to :category

  has_many :subproducts, -> { order(weight: 'desc') },
    dependent: :destroy
  has_one :max_subproduct, -> { order(weight: 'desc') },
    class_name: :Subproduct

  has_one :min_subproduct, -> { order(weight: 'asc') },
    class_name: :Subproduct

  has_many :evaluations, dependent: :destroy

  has_many :product_params, dependent: :destroy

  has_many :product_photos, -> { order(weight: 'desc') },
    dependent: :destroy
  has_one :main_product_photo, -> { order(weight: 'desc') },
    class_name: :ProductPhoto

end
