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
     if @order.aasm_state == "paid"

       @order.ship!
       carriage_method = params[:carriage_method]
       product_name = @order.product_lists.first.product_name
       carriage_no = params[:carriage_no]
       ChinaSMS.use :yunpian, password: ENV["sms_ship"]
       ChinaSMS.to @order.user.cellphone, "【大赛加油站】您购买的#{product_name}:已被#{carriage_method}揽收，#{carriage_no}，愿她以火箭般的速度飞到您手中！目前物流动态功能尚在开发中。期待[大赛加油站]成为你5票中的1票：http://t.cn/RSSdARt"
       @order.update_column :carriage_no, params[:carriage_no]
       @order.update_column :carriage_method, params[:carriage_method]
       if @order.save
         redirect_to admin_orders_path, notice: "success!"
       else
         redirect_to :back, alert: "出错啦~"
       end
     else
     redirect_to :back, alert: "当前订单非待发货状态哦"
   end
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
