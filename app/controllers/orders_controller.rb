class OrdersController < ApplicationController
  before_action :find_order_by_token, only: [:show, :pay_with_wechat, :pay_with_alipay]
  layout 'product'

  def build_order
    @subproduct = Subproduct.find(params[:subproduct_id])
    @amount = params[:amount]
  end

  def create
    if order_token = Order.create_order!(params, order_params)
      redirect_to generate_pay_payments_path(:id => order_token)
    else
      redirect_to :back, notice: "生成订单失败，请稍后客服~"
    end
  end

  def order_create
    order_token = Order.generate_order!(params, current_user)
    redirect_to generate_pay_payments_path(:id => order_token)
  end

  def lesson_order_create
    order_token = Order.generate_lesson_order(params)
    redirect_to lesson_generat_pay_payments_path(:id => order_token)
  end

  def show
   @product_lists = @order.product_lists
   @evaluation = Evaluation.new
  end

  def pay_with_wechat
    @order.set_payment_with!("wechat")
    @order.make_payment!
    redirect_to order_path(@order.token), notice: "使用微信成功完成付款！"
  end

  def pay_with_alipay
    @order.set_payment_with!"alipay"
    @order.make_payment!
    redirect_to order_path(@order.token),notice: "使用支付宝成功完成付款!"
  end

  def apply_to_cancel
    @order = Order.find(params[:id])
    OrderMailer.apply_cancel(@order).deliver!
    redirect_to :back, notice: "已提交申请！"
  end

  private
  def order_params
     params.require(:order).permit(:total, :user_id, :created_at, :updated_at, :token, :is_paid, :payment_method, :aasm_state, :payment_id, :carriage, :of_lesson, :lesson_id, :payment_id)
  end

  def find_order_by_token
    @order = Order.find_by_token(params[:id])
  end
end
