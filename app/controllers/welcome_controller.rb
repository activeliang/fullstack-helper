class WelcomeController < ApplicationController


  def index
    @slider_images = SliderPhoto.where(:is_hidden => false).order(weight: "desc")
    @products = Product.limit(4)
  end


  def test
    @rand_products = Product.order("RANDOM()").limit(3)
  end
end
