module LessonsHelper

  def is_buyer?
    lesson.buyers.include?(current_user)
  end
end
