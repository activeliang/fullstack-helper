class UsersController < ApplicationController
skip_before_action :require_login, only: [:new, :create]
# 用户在注册时不需要验证是否已经登录
  def new
    @user = User.new
  end

  def create
    @user =User.new(user_params)
    #
    # if verify_rucaptcha?(@user) && @user.save
    #   flash[:notice] = "注册成功，请登录"
    #   redirect_to new_session_path
    # else
    #   @user.errors.add(:base, t('rucaptcha.invalid'))
    #   render action: :new
    # end

    # phonenumber = User.find_by_cellphone(params[:cellphone])
    # if !phonenumber.nil?
    #   flash[:notice] = '手机号已被注册了哦～'
    #   render action: :new
    # else
      # if !verify_rucaptcha?(@user)
      #     flash[:alert]= '验证码不正确'
      #     render action: :new
      # else
      if @user.save
        flash[:notice] = '注册成功，请登录'
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

    # def generate_rucaptcha
    #   res = RuCaptcha.generate()
    #   session_val = {
    #     code: res[0],
    #     time: Time.now.to_i
    #   }
    #   RuCaptcha.cache.write(rucaptcha_sesion_key_key, session_val, expires_in: RuCaptcha.config.expires_in)
    #   res[1]
    # end

    private

    def user_params
      params.require(:user).permit(:password, :password_confirmation, :cellphone, :token)
    end
end
