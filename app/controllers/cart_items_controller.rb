class CartItemsController < ApplicationController

  def destroy
    @cart_item = current_cart.cart_items.find_by(product_id: params[:id])
    @product = @cart_item.product
    @cart_item.destroy
    redirect_to :back, warning: "成功将#{@product.title}移出购物车。"
  end

  def update
    @cart_item = current_cart.cart_items.find_by(product_id: params[:id])
    if @cart_item.product.quantity >= cart_item_params[:quantity].to_i
      @cart_item.update(cart_item_params)
      flash[:notice] = "update success!"
    else
      flash[:warning] = "数量不足以加入购物车！"
    end
    redirect_to :back
  end

  private
  def cart_item_params
    params.require(:cart_item).permit(:quantity)

  end
end
