class Cart < ApplicationRecord

  has_many :cart_items
  has_many :subproducts, through: :cart_items, source: :subproduct

  def add_product_to_cart(subproduct, amount)
    ci = cart_items.build
    ci.subproduct = subproduct
    ci.quantity = amount.to_i
    ci.save
  end

  def update_quantity(subproduct, amount)
    ci = cart_items.find_by_subproduct_id(subproduct)
    ci.quantity += amount.to_i
    ci.save
  end

  def total_price
    sum = 0
    cart_items.each do |cart_item|
      if cart_item.is_selected?
        if cart_item.subproduct.price.present?
          sum += cart_item.subproduct.price * cart_item.quantity
        end
      end
    end
    sum
  end

  def carriage_price
    sum = []
    cart_items.each do |cart_item|
      if cart_item.is_selected?
        sum << cart_item.subproduct.carriage
      end
    end
    sum.max
  end

  def update_cart!(params)
    params.delete("utf8")
    params.delete("authenticity_token")
    params.delete("select-item")
    self.cart_items.each do |cart_item|
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
  end

  def clean!
    self.cart_items.where(:is_selected => true).destroy_all
  end
end
