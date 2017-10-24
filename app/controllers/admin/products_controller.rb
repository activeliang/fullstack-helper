class Admin::ProductsController < ApplicationController
  before_action :admin_required
  before_action :find_product, only: [:show, :edit, :update, :destroy]
  layout "admin"

  def new
    @product = Product.new
    @root_categories = Category.all
  end

  def show
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
  end

  def update
    if @product.update(product_params)
      redirect_to admin_products_path,notice:"update success!"
    else
      render :edit
    end
  end

  def destroy
    if @product.destroy
      redirect_to :back, warning: "Deleted!"
    end
  end


  private
  def find_product
    @product = Product.find(params[:id])
  end
  def product_params
    params.require(:product).permit(:title, :description, :quantity, :price, :image, :category_id, :slogan)
  end
end
