class Account::OrdersController < ApplicationController
  before_action :auth_user

  def index
    @orders = current_user.orders.order("id DESC")
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel_order!
    redirect_to :back, notice: '订单已关闭！'
  end

  def shipped
    @order = Order.find(params[:id])
    @order.deliver!
    redirect_to :back
  end
end
