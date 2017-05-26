class CartsController < ApplicationController

  def clean
    current_cart.cart_items.destroy_all
    redirect_to :back, alert: "Deleted!"
  end

  def checkout
    @order = Order.new
  end

  def random_product
    @product = Product.order("RANDOM()").limit(3)
  end
end
