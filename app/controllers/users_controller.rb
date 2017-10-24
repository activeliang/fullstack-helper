class UsersController < ApplicationController
  skip_before_action :auth_user, only: [:new, :create]

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
    @user.is_overseas = params[:user][:type] == "0" ? false : true
    if @user.save
      flash[:notice] = '注册成功～'
      redirect_to new_session_path
    else
      @user.errors
      render action: :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :cellphone, :token, :username)
  end
end
