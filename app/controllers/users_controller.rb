class UsersController < ApplicationController
skip_before_action :auth_user, only: [:new, :create]

# 用户在注册时不需要验证是否已经登录


  def new
    @user = User.new
  end

  def is_buyer?(lesson)
    buyer_id = lesson.buyers.map{|x| x.user_id}
    buyer_id.include?(current_user)
  end

  def create
    @user =User.new(user_params)
    @user.username = params[:user][:username]
    binding.pry
    if params[:user][:type] == "0"
      @user.is_overseas = false
    else
      @user.is_overseas = true
    end

      if @user.save
        flash[:notice] = '注册成功～'
        redirect_to new_session_path
      else
        @user.errors
        render action: :new
        end

    # end
    # @test3 = params[:user][:cellphone]
    # @cellphone = params[:cellphone]
    # @id2 = params[:_rucaptcha]
    # redirect_to test_path(:id => @cellphone, :id2 => @id2, :id3 => @test3)
  end

    # def username
    #   @username = User.find_by_cellphone(params[:username])
    # end

    # def check_cellphone_unrepeated
    #   phonenumber = User.find_by_cellphone(params[:cellphone])
    #     if phonenumber.present?
    #       # redirect_back_or_to "/sessions/new", notic: "You are not admin."
    #       render :json => {status: "gologin"}
    #     return false
    #     else
    #     return true
    #     end
    # end

    private

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :cellphone, :token, :username)
    end
end
