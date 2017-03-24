class CartsController < ApplicationController

  def clean
    current_cart.cart_items.destroy_all
    redirect_to :back, alert: "Deleted!"
  end
end
