class ProductsController < ApplicationController
    layout 'product'
  def index
    @products = Product.all
  end

  def show

    @product = Product.find(params[:id])
    @rand_products = Product.order("RANDOM()").limit(3)
  end

  def add_to_cart
    @test = params[:amount]
    @product = Product.find(params[:id])
    @subproduct = @product.subproducts.find(params[:subproduct_id])
    if !current_cart.subproducts.include?(@subproduct)
    current_cart.add_product_to_cart(@subproduct, params[:amount])

    render :json => { :title => @subproduct.subtitle, :message => "ok" }
  else
    current_cart.update_quantity(@subproduct, params[:amount])
    render :json => { :title => @subproduct.subtitle, :message => "ok", :test => params[:amount] }
  end
  end

end
