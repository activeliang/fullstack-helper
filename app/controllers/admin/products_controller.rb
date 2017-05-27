class Admin::ProductsController < ApplicationController
  before_action :admin_required

  layout "admin"

  def new
    @product = Product.new
    @root_categories = Category.all
  end

  def show
    @product = Product.find(params[:id])
    @subproducts = @product.subproducts
    @subproduct = Subproduct.new
    @product_params = @product.product_params
    @product_param = ProductParam.new
    @product_photos = @product.product_photos
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to admin_products_path,notice:"create success!"
    else
      render :new
    end
  end

  def index
    @products = Product.all
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to admin_products_path,notice:"update success!"
    else
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      redirect_to :back, warning: "Deleted!"
    end
  end


  private
  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :image, :category_id, :slogan)
  end
end
