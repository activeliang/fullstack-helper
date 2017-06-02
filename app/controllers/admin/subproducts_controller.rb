class Admin::SubproductsController < ApplicationController
  before_action :admin_required

  def create
    @product = Product.find(params[:product_id])
    @subproduct = Subproduct.new(subproduct_params)
    @subproduct.product = @product
    if @subproduct.save
      redirect_to admin_product_path(@product), notice: "created!"
    else
      redirect_to :back
    end
  end

  def destroy
    @product = Product.find(params[:product_id])
    @subproduct = @product.subproducts.find(params[:id])
    if @subproduct.destroy
      redirect_to admin_product_path(@product), alert: "Deleted!"
    else
      redirect_to :back
    end
  end

  def update
    @product = Product.find(params[:product_id])
    @subproduct = @product.subproducts.find(params[:id])
    @subproduct.weight = params[:weight]
    if @subproduct.save
      flash[:notice] = "修改成功！"
    else
      flash[:warning] = "修改失败！"
    end
    redirect_to :back
  end

  private

  def subproduct_params
    params.require(:subproduct).permit(:subtitle, :msrp, :price, :activity, :carriage, :place, :quantity, :subproduct_image, :weight)
  end
end
