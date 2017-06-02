class Admin::LessonsController < ApplicationController
  layout 'admin'

  def index
    @lessons = Lesson.all
  end

  def show
    @lesson = Lesson.find(params[:id])
    @chapter = Chapter.new
    @chapters = @lesson.chapters
    @post = Post.new
  end

  def new
    @lesson = Lesson.new
    @root_categories = Category.all
  end

  def create
    @lesson = Lesson.new(lesson_params)
    if @lesson.save
      redirect_to admin_lessons_path, notice: "create success!"
    else
      redirect_to :back, warning: "新增失败！"
    end
  end

  def edit
    @root_categories = Category.all
    @lesson = Lesson.find(params[:id])
  end

  def update
    @lesson = Lesson.find(params[:id])
    if @lesson.update(lesson_params)
      redirect_to :back, notice: "updated!"
    else
      redirect_to :back, warning: "failed!"
    end
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    if @lesson.destroy
      redirect_to :back, warning: "Deleted!"
    end
  end

  private
  def lesson_params
    params.require(:lesson).permit(:title, :intro, :description, :subtitle, :main_image, :minor_image, :price, :weight, :effect, :category_id)
  end
end
