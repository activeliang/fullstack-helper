class Admin::PostsController < ApplicationController

  def create
    @post = Post.new(post_params)
    binding.pry
    @post.chapter_id = params[:post][:chapter_id]
    if @post.save
      redirect_to :back, notice: "success!"
    else
      redirect_to :back, alert: "failed!"
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @lesson = Lesson.find(params[:lesson_id])
    @post = Post.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:lesson_id])
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to admin_lesson_path(@lesson), notice: "success!"
    else
      redirect_to :back, warning: "failed!"
    end
  end

  def update_weight
    @post = Post.find(params[:id])
    @post.weight = params[:weight]
    if @post.save
      redirect_to :back, notice: "success!"
    else
      redirect_to :back, alert: "failed!"
    end
  end

  private
  def post_params
    params.require(:post).permit(:title, :weight, :description)
  end
end
