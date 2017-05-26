class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params.require(:user)
      .permit(:password, :password_confirmation, :cellphone, :token))
    #
    # if verify_rucaptcha?(@user) && @user.save
    #   flash[:notice] = "注册成功，请登录"
    #   redirect_to new_session_path
    # else
    #   @user.errors.add(:base, t('rucaptcha.invalid'))
    #   render action: :new
    # end

    if current_user.include?(@user)
      flash[:notice] = '手机号已被注册了哦～'
      render action: :new
    else
      if !verify_rucaptcha?(@user)
          generate_rucaptcha, flash[:alert]= '验证码不正确'
          render action: :new
      else
         if @user.save
           flash[:notice] = '注册成功，请登录'
           redirect_to new_session_path
         else
           @user.errors
           render action: :new
         end
      end
    end

  end

    def generate_rucaptcha
      res = RuCaptcha.generate()
      session_val = {
        code: res[0],
        time: Time.now.to_i
      }
      RuCaptcha.cache.write(rucaptcha_sesion_key_key, session_val, expires_in: RuCaptcha.config.expires_in)
      res[1]
    end

  end
