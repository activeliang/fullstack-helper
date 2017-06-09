class PostsController < ApplicationController
  # before_action :auth_buyer
  def show
    @post = Post.find(params[:id])
    @chapter = @post.chapter
    @lesson = @chapter.lesson
    @post_eva = PostEva.new
    posts = @lesson.posts

    buyer_id = @lesson.buyers.map{|x| x.user_id}
    # unless buyer_id.include?(current_user.id) || !current_user.is_admin?
    #   redirect_to lesson_path(@lesson), notice: "您未购买此课程哦~~"
    # end

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

  def upvote
    @post = Post.find(params[:id])
    binding.pry
    @post.update_column :so_easy, @post.so_easy +=1
    render :json => "ok"
  end

  def downvote
    @post = Post.find(params[:id])
    @post.update_column :okay, @post.okay -=1
    render :json => "ok"
  end

end
