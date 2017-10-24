class Evaluation < ApplicationRecord
  belongs_to :product
  has_many :evaluation_photos
end
