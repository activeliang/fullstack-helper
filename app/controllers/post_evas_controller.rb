class PostEvasController < ApplicationController

  def create
    @post_eva = PostEva.new(post_eva_params)
    if @post_eva.save
      render :json => {status: "ok"}
    end
  end

  private
  def post_eva_params
    params.require(:post_eva).permit(:content, :eva_image)
  end
end
