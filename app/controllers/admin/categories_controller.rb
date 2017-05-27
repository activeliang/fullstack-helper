class Admin::CategoriesController < ApplicationController
  before_action :admin_required
  layout 'admin'
  def index
    @category = Category.new
    @categories = Category.all
  end



  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to admin_categories_path, notice: "created!"
    else
      redirect_to :back
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to admin_categories_path, alert: "deleted!"
    else
      redirect_to :back
    end
  end

  private
  def category_params
    params.require(:category).permit(:title)
  end

end
