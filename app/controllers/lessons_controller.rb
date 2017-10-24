class LessonsController < ApplicationController
  skip_before_action :auth_user, only:[:show]

  def show
    @lesson = Lesson.find(params[:id])
  end

  def syllabus
    @lesson = Lesson.find(params[:id])
    if is_buyer?(@lesson)
      @chapters = @lesson.chapters
    else
      redirect_to lesson_path(@lesson),warning: "请先购买再学习~"
    end
  end


end
