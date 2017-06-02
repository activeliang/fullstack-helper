class CartsController < ApplicationController

  def clean
    current_cart.cart_items.destroy_all
    redirect_to :back, alert: "Deleted!"
  end

  def checkout
    @order = Order.new
  end

  def update_cart
    params.delete("utf8")
    params.delete("authenticity_token")
    params.delete("select-item")
    # params.delete("controller")

    current_cart.cart_items.each do |cart_item|
      cart_item.is_selected = false
      cart_item.save
    end
    params.each do |k, v|
      if k.to_i != 0
        selected_item = current_cart.cart_items.find(k.to_i)
        selected_item.is_selected = true
        selected_item.quantity = v["quantity"]
        selected_item.save
      end
    end

    redirect_to checkout_carts_path

  end

  def random_product
    @product = Product.order("RANDOM()").limit(3)
  end
end
