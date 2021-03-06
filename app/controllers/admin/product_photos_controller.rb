class Admin::ProductPhotosController < ApplicationController
  before_action :admin_required
  before_action :find_product_image

  def index
    @product_photos = @product.product_photos
  end

  def create
    params[:images].each do |image|
      @product.product_photos << ProductPhoto.new(product_image: image)
    end
    redirect_to :back
  end

  def destroy
    @product_image = @product.product_photos.find(params[:id])
    if @product_image.destroy
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "删除失败"
    end
    redirect_to :back
  end

  def update
    @product_image = @product.product_photos.find(params[:id])
    if @product_image.update_column weight: params[:weight]
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end
    redirect_to :back
  end

  private
  def find_product_image
    @product = Product.find params[:product_id]
  end
end
