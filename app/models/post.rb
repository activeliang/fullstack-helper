class Post < ApplicationRecord
  belongs_to :chapter
  has_many :post_evas
end
