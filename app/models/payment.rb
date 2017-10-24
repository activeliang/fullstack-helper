class Payment < ApplicationRecord
  before_create :gen_payment_no

  module PaymentStatus
    Initial = 'initial'
    Success = 'success'
    Failed = 'failed'
  end

  belongs_to :user
  has_many :orders

  def is_success?
    self.status == "success"
  end

  def do_success_payment! params
    self.transaction do
      self.transaction_no = params[:trade_no]
      self.status = Payment::PaymentStatus::Success
      self.raw_response = params.to_json
      self.payment_at = Time.now
      self.save
      # 更新订单状态
      self.orders.each do |order|
        if order.is_paid?
          raise "order #{order.order_no} has alreay been paid"
        end
          order.payment_at = Time.now
          order.make_payment!
          order.is_paid = true
          order.payment_method = "alipay"
          order.save

        if !order.of_lesson?
          order.product_lists.each do |product_list|
            product = Product.find(product_list.product_id)
            product.sales_count += 1
            product.save
          end
        end

        if order.of_lesson?
          lesson = Lesson.find(order.lesson_id)
          lesson.sales_count += 1
          lesson.save
          buyer = Buyer.new
          buyer.price = lesson.price
          buyer.user_id = order.user_id
          buyer.lesson_id = order.lesson_id
          buyer.save
        end
      end
    end
  end

  def do_failed_payment! params
    self.transaction_no = params[:trade_no]
    self.status = Payment::PaymentStatus::Failed
    self.raw_response = params.to_json
    self.payment_at = Time.now
    self.save!
  end

  def self.create_from_orders! user, order
    payment = nil
    transaction do
      payment = user.payments.create!(total_money: order.total)
      raise "order #{order.order_no} has alreay been paid" if order.is_paid?
      order.payment_id = payment
      order.save!
    end
    payment
  end

  def self.lesson_order_create!(params)
    order = current_user.orders.find_by_token(params[:id])
    payment = Payment.new
      payment.total_money = order.total
      payment.user = current_user
      payment.save!
      if payment.save && order.is_paid?
        redirect_to order_path(order.token), alert: "该订单已支付！"
      else
        order.payment = payment
        order.save!
      end
    return payment
  end

  private

  def gen_payment_no
    self.payment_no = generate_utoken(32)
  end

  def generate_utoken len = 8
    a = lambda { rand(36).to_s(36) }
    token = ""
    len.times { |t| token << a.call.to_s }
    token
  end
end
