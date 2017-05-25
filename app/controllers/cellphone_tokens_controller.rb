class CellphoneTokensController < ApplicationController
  def create
    unless params[:cellphone] =~ User::CELLPHONE_RE
      render json: {status: 'error', message: "手机号格式不正确！"}
      return
    end

    if session[:token_created_at] and
      session[:token_created_at] + 60 > Time.now.to_i
      render json: {status: 'error', message: "请稍后再试！"}
      return
    end

    ChinaSMS.use :yunpian, password: 'a5d0fad8d28413239fe0123e22885c20'
    token = generate_cellphone_token
    VerifyToken.upsert params[:cellphone], token
    ChinaSMS.to params[:cellphone], "【全栈助手】感谢您注册fullstackhelper，您的验证码是#{token} "
    session[:token_created_at] = Time.now.to_i
    render json: {status: 'ok'}
  end

    def generate_cellphone_token len = 6
      a = lambda { (0..9).to_a.sample }
      token = ""
      len.times { |t| token << a.call.to_s }
      token
    end


end
