class OrdersController < ApplicationController


  layout 'product'
  def build_order
    @subproduct = Subproduct.find(params[:subproduct_id])
    @amount = params[:amount]
  end

  def create
    order = Order.new(order_params)
    address = current_user.addresses.find(params[:address_id])
    order.user = current_user
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
             product_list.lists_image = cart_item.subproduct.subproduct_image
             product_list.save!

           end
        end
          current_cart.clean!
          redirect_to generate_pay_payments_path(:id => order.token)
      else
         redirect_to root_path, alert: "生成订单失败，请联系客服！"
      end
  end

  def order_create
    subproduct = Subproduct.find(params[:subproduct_id])
    address = current_user.addresses.find(params[:address_id])
    quantity = params[:quantity].to_i
    order = Order.new

     order.total = subproduct.price * quantity + subproduct.carriage
     order.user = current_user
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
      product_list.lists_image = subproduct.subproduct_image
      product_list.save!

    end

    redirect_to generate_pay_payments_path(:id => order.token)
  end

  def lesson_order_create
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
        product_list.lists_image = lesson.main_image
        product_list.save


    redirect_to lesson_generat_pay_payments_path(:id => order.token)
    end



  end

  def show
   @order = Order.find_by_token(params[:id])
   @product_lists = @order.product_lists
   @evaluation = Evaluation.new
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

  end
end
