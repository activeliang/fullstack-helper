class CellphoneTokensController < ApplicationController
  prepend_before_action :valify_captcha!, only: [:create]

  skip_before_action :require_login, only: [:create]
  # prepend_before_action :valify_phone_unrepeated!

  def create
    unless params[:cellphone] =~ User::CELLPHONE_RE
      render json: {status: 'error', message: "手机号格式不正确！"}
      return
    end

    if session[:token_created_at] and
      session[:token_created_at] + 60 > Time.now.to_i
      render json: {status: 'error', message: "您已经申请过验证码啦，请60s后再试哦！"}
      return
    end

    ChinaSMS.use :yunpian, password: ENV["sms_signup"]
    token = generate_cellphone_token
    VerifyToken.upsert params[:cellphone], token
    ChinaSMS.to params[:cellphone], "【大赛加油站】#{token}(注册验证码)，请在15分钟内完成注册。如非本人操作，请忽略。"
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

    # def valify_phone_unrepeated!
    #   phonenumber = User.find_by_cellphone(params[:cellphone])
    #     if phonenumber.present?
    #       # redirect_back_or_to "/sessions/new", notic: "You are not admin."
    #       render :json => {status: "gologin"}
    #     return false
    #     else
    #     return true
    #     end
    # end


    # def generate_rucaptcha
    #   res = RuCaptcha.generate()
    #   session_val = {
    #     code: res[0],
    #     time: Time.now.to_i
    #   }
    #   RuCaptcha.cache.write(rucaptcha_sesion_key_key, session_val, expires_in: RuCaptcha.config.expires_in)
    #   res[1]
    # end
end
