class Admin::ProductParamsController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @product_param = ProductParam.new(product_param_params)
    @product_param.product = @product
    if @product_param.save
      redirect_to admin_product_path(@product), notice: "created!"
    else
      redirect_to :back
    end
  end

  def destroy
    @product = Product.find(params[:product_id])
    @product_param = @product.product_params.find(params[:id])
    if @product_param.destroy
      redirect_to admin_product_path(@product), alert: "Deleted!"
    else
      redirect_to :back
    end
  end


  private

  def product_param_params
    params.require(:product_param).permit(:weight, :content)
  end
end
