class Chapter < ApplicationRecord
  belongs_to :lesson
  has_many :posts, -> { order(weight: 'desc') },
    dependent: :destroy
end
