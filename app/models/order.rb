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
      orders << user.orders.create!(total: cart.total_price,payment_id: 1 )
      end
      cart.clean!
    end
    orders
  end

  def order_ship!(params)
    if @order.aasm_state == "paid"
      @order.ship!
      ChinaSMS.use :yunpian, password: ENV["sms_ship"]
      ChinaSMS.to @order.user.cellphone, "【大赛加油站】您购买的#{@order.product_lists.first.product_name}:已被#{params[:carriage_method]}揽收，#{params[:carriage_no]}，愿她以火箭般的速度飞到您手中！目前物流动态功能尚在开发中。期待[大赛加油站]成为你5票中的1票：http://t.cn/RSSdARt"
      if @order.update_columns carriage_no: params[:carriage_no], carriage_method: params[:carriage_method]
        return "success!"
      else
        return "出错啦~"
      end
    else
      return "当前订单非待发货状态哦"
    end
  end

  def self.create_order!(params, order_params)
    address = current_user.addresses.find(params[:address_id])
    order = current_user.orders.new(order_params)
    order.carriage = current_cart.carriage_price
    order.total = current_cart.total_price + order.carriage
    order.save!
      if order.save
        current_cart.cart_items.each do |cart_item|
           if cart_item.is_selected?
             cart_item.subproduct.update_column :quantity, cart_item.subproduct.quantity - cart_item.quantity
             product_list = ProductList.new
             product_list.order_id = order.id
             product_list.product_name = cart_item.subproduct.product.title
             product_list.product_price = cart_item.subproduct.price
             product_list.quantity = cart_item.quantity
             product_list.address = address.address
             product_list.cellphone = address.cellphone
             product_list.contact_name = address.contact_name
             product_list.subproduct = cart_item.subproduct.subtitle
             product_list.product_id = cart_item.subproduct.product_id
             product_list.lists_image = cart_item.subproduct.subproduct_image.thumb
             product_list.save!
           end
        end
          current_cart.clean!
          return order.token
      else
         return false
      end
  end

  def self.generate_order!(params, current_user)
    subproduct = Subproduct.find(params[:subproduct_id])
    address = current_user.addresses.find(params[:address_id])
    quantity = params[:quantity].to_i
    order = current_user.orders.new
       order.total = subproduct.price * quantity + subproduct.carriage
       order.carriage = subproduct.carriage
       order.save!
       if order.save
          subproduct.update_column :quantity, subproduct.quantity - quantity
          product_list = ProductList.new
          product_list.order_id = order.id
          product_list.product_name = subproduct.product.title
          product_list.product_price = subproduct.price
          product_list.quantity = quantity
          product_list.address = address.address
          product_list.cellphone = address.cellphone
          product_list.contact_name = address.contact_name
          product_list.subproduct = subproduct.subtitle
          product_list.product_id = subproduct.product_id
          product_list.lists_image = subproduct.subproduct_image.thumb
          product_list.save!
       end
    return order.token
  end

  def self.generate_lesson_order(params)
    lesson = Lesson.find(params[:lesson_id])
    if lesson.present?
      order = Order.new
        order.total = lesson.price
        order.user = current_user
        order.of_lesson = true
        order.lesson_id = lesson.id
        order.save
        product_list = ProductList.new
          product_list.order = order
          product_list.product_name = lesson.title
          product_list.product_price = lesson.price
          product_list.lists_image = lesson.minor_image.thumb
          product_list.quantity = 1
          product_list.save!
      return order.token
    end
  end

  def generate_pay!(current_user)
    payment = Payment.new
      payment.total_money = self.total
      payment.user = current_user
      payment.save!
      if payment.save
        if self.is_paid?
          redirect_to order_path(self.token), alert: "该订单已支付！"
        else
          self.payment = payment
          self.save!
        end
      end
    return payment.payment_no
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
