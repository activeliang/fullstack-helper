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
      if cart_item.subproduct.price.present?
        sum += cart_item.subproduct.price * cart_item.quantity
      end
    end
    sum
  end

  def clean!
    self.cart_items.destroy_all
  end
end
