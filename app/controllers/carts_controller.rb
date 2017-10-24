class CartsController < ApplicationController
  skip_before_action :auth_user
  layout 'product'

  def clean
    current_cart.cart_items.destroy_all
    redirect_to :back, alert: "Deleted!"
  end

  def checkout
    @order = Order.new
  end

  def update_cart
    current_cart.update_cart!(params)
    redirect_to checkout_carts_path
  end

  def random_product
    @product = Product.order("RANDOM()").limit(3)
  end
end
