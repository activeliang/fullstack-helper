class Admin::ChaptersController < ApplicationController

  def new
     @chapter = Chapter.new
  end

  def show
    @chapter = Chapter.find(params[:id])
    @posts = @chapter.posts
  end

  def create
    @chapter = Chapter.new(chapter_params)
    @chapter.lesson_id = params[:lesson_id]
    binding.pry
    if @chapter.save
      redirect_to :back, notice: "success!"
    else
      redirect_to :back, alert: "failed!"
    end
  end

  def edit
    @lesson = Lesson.find(params[:lesson_id])
    @chapter = @lesson.chapters.find(params[:id])
  end

  def update
    @chapter = Chapter.find(params[:id])
    if params[:weight].present?
      @chapter.weight = params[:weight]
    end 
    if params[:chapter].present?
      @chapter.title = params[:chapter][:title]
    end
    if @chapter.save
      redirect_to :back, notice: "success!"
    else
      redirect_to :back, alert: "failed!"
    end
  end

  def destroy
    @chapter = Chapter.find(params[:id])
    if @chapter.destroy
      redirect_to :back, warning: "Deleted!"
    end
  end

  private

  def chapter_params
    params.require(:chapter).permit(:title, :weight)
  end
end
