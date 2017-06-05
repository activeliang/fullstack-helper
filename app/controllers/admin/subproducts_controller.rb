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

  def edit
    @product = Product.find(params[:product_id])
    @subproduct = @product.subproducts.find(params[:id])
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

  def update_weight
    @product = Product.find(params[:product_id])
    @subproduct = @product.subproducts.find(params[:id])
    @subproduct.weight = params[:weight]
    if @subproduct.save
      redirect_to :back, notice: "success!"
    else
      redirect_to :back, alert: "failed!"
    end
  end

  def update
    @product = Product.find(params[:product_id])
    @subproduct = @product.subproducts.find(params[:id])
    @subproduct.weight = params[:weight]
    if @subproduct.update(subproduct_params)
      flash[:notice] = "修改成功！"
      redirect_to admin_product_path(@product)
    else
      flash[:warning] = "修改失败！"
      redirect_to :back
    end

  end

  private

  def subproduct_params
    params.require(:subproduct).permit(:subtitle, :msrp, :price, :activity, :carriage, :place, :quantity, :subproduct_image, :weight)
  end
end
