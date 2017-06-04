class WelcomeController < ApplicationController
  skip_before_action :auth_user

  layout 'application'
  def index
    @slider_images = SliderPhoto.where(:is_hidden => false).order(weight: "desc")
    @products = Product.limit(4)
    @lessons = Lesson.limit(4)
  end




  def test

  end
end
