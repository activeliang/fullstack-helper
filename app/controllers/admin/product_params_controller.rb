class Admin::ProductParamsController < ApplicationController
  before_action :admin_required
  before_action :find_product_params

  def create
    @product_param = @product.product_params.new(product_param_params)
    if @product_param.save
      redirect_to admin_product_path(@product), notice: "created!"
    else
      redirect_to :back
    end
  end

  def destroy
    @product_param = @product.product_params.find(params[:id])
    if @product_param.destroy
      redirect_to admin_product_path(@product), alert: "Deleted!"
    else
      redirect_to :back
    end
  end


  private

  def find_product_params
    @product = Product.find(params[:product_id])
  end

  def product_param_params
    params.require(:product_param).permit(:weight, :content)
  end
end
