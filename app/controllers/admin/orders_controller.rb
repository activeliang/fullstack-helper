class Admin::OrdersController < ApplicationController
  before_action :admin_required
  layout "admin"

  def index
    @orders = Order.order("id DESC")
  end

  def show
    @order = Order.find(params[:id])
    @product_lists = @order.product_lists
  end

  def ship_page
    @order = Order.find(params[:id])
    if @order.aasm_state != "paid"
      redirect_to :back, alert: "此订单非待发货状态哦~"
    end
  end

  def ship
     @order = Order.find(params[:id])
     redirect_to :back, notice: @order.order_ship!(params)
  end

  def shipped
    @order = Order.find(params[:id])
    @order.deliver!
    redirect_to :back
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel_order!
    redirect_to :back, notice: "order canceled!"
  end

  def return
    @order = Order.find(params[:id])
    @order.return_good!
    redirect_to :back
  end
end
