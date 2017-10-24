class CellphoneTokensController < ApplicationController
  prepend_before_action :valify_captcha!, only: [:create]

  skip_before_action :auth_user, only: [:create]
  prepend_before_action :valify_phone_unrepeated!

  def create
    if params[:helper] == 0
      unless params[:cellphone] =~ User::CELLPHONE_RE
        render json: {status: 'error', message: "手机号格式不正确！"}
        return
      end
    end


    if session[:token_created_at] and
      session[:token_created_at] + 60 > Time.now.to_i
      render json: {status: 'error', message: "您已经申请过验证码啦，请60s后再试哦！"}
      return
    end

    ChinaSMS.use :yunpian, password: ENV["sms_signup"]
    token = generate_cellphone_token
    VerifyToken.upsert params[:cellphone], token
      if params[:helper] == "0"
        ChinaSMS.to params[:cellphone], "【大赛加油站】#{token}(注册验证码)，请在15分钟内完成注册。如非本人操作，请忽略。"
      else
        ChinaSMS.to params[:cellphone], "【大賽加油站】#{token}(註冊驗證碼)，請在15分鐘內完成註冊。如非本人操作，請忽略。"
      end
    session[:token_created_at] = Time.now.to_i
    render json: {status: 'ok'}
  end

  def generate_cellphone_token len = 6
    a = lambda { (0..9).to_a.sample }
    token = ""
    len.times { |t| token << a.call.to_s }
    token
  end

  def valify_captcha!
    unless verify_rucaptcha?
      render json: {status: 'error', message: "图形验证码不正确或者已经过期，请刷新重试"}
      return
    end
    true
  end

  def valify_phone_unrepeated!
    phonenumber = User.find_by_cellphone(params[:cellphone])
      if phonenumber.present?
        render :json => {status: "gologin"}
        return false
      else
        return true
      end
  end

end
