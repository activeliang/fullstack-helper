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

  def ship
     @order = Order.find(params[:id])
     @order.ship!
     ChinaSMS.use :yunpian, password: ENV["sms_pay"]
     ChinaSMS.to @payment.user.cellphone, "【大赛加油站】您的订单已发货！可进入个人订单查看物流动态。希望成为你5票中的1票：http://t.cn/RS6vf95"
     redirect_to :back
  end

  def shipped
    @order = Order.find(params[:id])
    @order.deliver!
    redirect_to :back
  end

  def cancel
    @order = Order.find(params[:id])
    @order.cancel_order!

    redirect_to :back
  end

  def return
    @order = Order.find(params[:id])
    @order.return_good!
    redirect_to :back
  end
end
