class SliderPhoto < ApplicationRecord

  mount_uploader :slider_image, SliderImageUploader
end
