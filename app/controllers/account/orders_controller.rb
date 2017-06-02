class Account::OrdersController < ApplicationController

  before_action :require_login



  def index
    @orders = current_user.orders.order("id DESC")
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel_order!
    redirect_to :back
  end

  def shipped
    @order = Order.find(params[:id])
    @order.deliver!
    redirect_to :back
  end
end
