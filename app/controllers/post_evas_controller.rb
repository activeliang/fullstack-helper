class PostEvasController < ApplicationController

  def create
    @post_eva = PostEva.new(post_eva_params)
    @post_eva.user = current_user
    @post_eva.post_id = params[:post_id]
    @post_eva.save
  end

  private
  def post_eva_params
    params.require(:post_eva).permit(:content, :eva_image)
  end
end
