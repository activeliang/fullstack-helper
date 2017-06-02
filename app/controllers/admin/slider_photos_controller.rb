class Admin::SliderPhotosController < ApplicationController
  before_action :admin_required

  layout 'admin'
  def index
    @slider_photos = SliderPhoto.all
  end

  def create
    params[:images].each do |image|
    @slider_photo = SliderPhoto.new(slider_image: image)
    end
    if @slider_photo.save
      redirect_to :back, notice: "created!"
    end
  end

  def destroy
    @slider_photo = SliderPhoto.find(params[:id])

    if @slider_photo.destroy
      flash[:notice] = "删除成功"
    else
      flash[:notice] = "删除失败"
    end

    redirect_to :back
  end

  def hide
    @slider_photo = SliderPhoto.find(params[:id])
    @slider_photo.update_column :is_hidden, true

      redirect_to :back, notice: "成功！"
  end

  def public
    @slider_photo = SliderPhoto.find(params[:id])
    @slider_photo.update_column :is_hidden, false

      redirect_to :back, notice: "成功！"
  end

  def update
    @slider_photo = SliderPhoto.find(params[:id])

    @slider_photo.weight = params[:weight]
    if @slider_photo.save
      flash[:notice] = "修改成功"
    else
      flash[:notice] = "修改失败"
    end

    redirect_to :back
  end

end
