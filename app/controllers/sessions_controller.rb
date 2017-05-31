class SessionsController < ApplicationController
  # prepend_before_action :valify_captcha!, only: [:create]
  skip_before_action :require_login, except: [:destroy]
  # 用户在退出时不需要验证是否已经登录

  def new

  end

  def create
    if user = login(params[:cellphone], params[:password])
      flash[:notice] = "登陆成功"
      redirect_back_or_to root_path
    else
      flash[:notice] = "手机号或者密码不正确"
      redirect_to new_session_path
    end
  end

  def destroy
    logout
    cookies.delete :user_uuid
    flash[:notice] = "退出成功"
    redirect_to root_path
  end

  def valify_captcha!
    binding.pry
    unless verify_rucaptcha?
      redirect_to new_session_path, alert: ('验证码不正确或者已过期')
      return
    end
    true
  end

end
