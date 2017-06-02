class PostsController < ApplicationController
  # before_action :auth_buyer
  def show
    @post = Post.find(params[:id])
    @chapter = @post.chapter
    @lesson = @chapter.lesson
    posts = @lesson.posts

    buyer_id = @lesson.buyers.map{|x| x.user_id}
    unless buyer_id.include?(current_user.id)
      redirect_to lesson_path(@lesson), notice: "您未购买此课程哦~~"
    end

    i = posts.index(@post)

    if posts.first == @post

      @left = nil
      @right = posts[ i + 1 ].id
    elsif posts.last == @post
      @left = posts[ i - 1 ].id
      @right = nil
    else
      @left = posts[ i - 1 ].id
      @right = posts[ i + 1 ].id
    end
  end

end
