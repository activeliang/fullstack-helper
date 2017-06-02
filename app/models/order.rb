class Order < ApplicationRecord
  before_create :generate_token
  belongs_to :user
  has_many :product_lists
  belongs_to :payment

  def generate_token
    self.token = SecureRandom.uuid
  end

  def set_payment_with!(method)
    self.update_columns(payment_method: method)
  end

  def pay!
    self.update_columns(is_paid: true)
  end

  def create_from_cart! user, cart, *order_params
    order_params.flatten!
    orders = []
    transaction do
      order_params.each do |order_param|
      orders << user.orders.create!(
      total: cart.total_price,
      payment_id: 1
      )
    end

    cart.clean!
    end

    orders
  end


  include AASM

  aasm do
    state :order_placed, initial: true
    state :paid
    state :shipping
    state :shipped
    state :order_cancelled
    state :good_returned

    event :make_payment, after_commit: :pay! do
      transitions from: :order_placed, to: :paid
    end

    event :ship do
      transitions from: :paid, to: :shipping
    end

    event :deliver do
      transitions from: :shipping, to: :shipped
    end

    event :return_good do
      transitions from: :shipped, to: :good_returned
    end

    event :cancel_order do
      transitions from: [:order_placed, :paid], to: :order_cancelled
    end
  end
end
