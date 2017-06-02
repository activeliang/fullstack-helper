module LessonsHelper

  def is_buyer?(lesson)
    buyer_id = lesson.buyers.map{|x| x.user_id}
    buyer_id.include?(current_user)
  end
end
