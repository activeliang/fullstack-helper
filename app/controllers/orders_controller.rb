class OrdersController < ApplicationController

  def create
    @order = Order.new(order_params)
    @order.total = current_cart.total_price
    @order.user = current_user
    @order.payment_id = 1

    if @order.save

      current_cart.cart_items.each do |cart_item|
        product_list = ProductList.new
        product_list.order = @order
        product_list.product_name = cart_item.product.title
        product_list.product_price = cart_item.product.price
        product_list.quantity = cart_item.quantity
        product_list.save
      end

      current_cart.clean!
    
      redirect_to generate_pay_payments_path(:id => @order.token)
    else
      redirect_to :back
    end
  end

  # def create
    # @order = Order.new(order_params)
    # @order1 = Order.new(order_params)
    # @order.total = current_cart.total_price
    # @order.user = current_user
    # # @order.payment_id = 1

    # orders = @order = Order.new.create_from_cart!(current_user, current_cart, order_params)


      #
      # current_cart.cart_items.each do |cart_item|
      #   product_list = ProductList.new
      #   product_list.order = @order
      #   product_list.product_name = cart_item.product.title
      #   product_list.product_price = cart_item.product.price
      #   product_list.quantity = cart_item.quantity
      #   product_list.save
      #
      #
      # current_cart.clean!
      # OrderMailer.notify_order_placed(@order).deliver!

      # redirect_to generate_pay_payments_path(order_token: orders[:token])
    # else
    #   redirect_to :back
    # end
  # end

  def show
   @order = Order.find_by_token(params[:id])
   @product_lists = @order.product_lists
  end

  def pay_with_wechat
    @order = Order.find_by_token(params[:id])
    @order.set_payment_with!("wechat")
    @order.make_payment!

    redirect_to order_path(@order.token), notice: "使用微信成功完成付款！"
  end

  def pay_with_alipay
    @order = Order.find_by_token(params[:id])
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
    params.require(:order).permit(:billing_name, :billing_address, :shipping_name, :shipping_address)
  end
end
