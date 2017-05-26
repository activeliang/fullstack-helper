class CellphoneTokensController < ApplicationController
  prepend_before_action :valify_captcha!, only: [:create]
  prepend_before_action :valify_phone_unrepeated!, only:[:create]

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


    def valify_captcha!
      unless verify_rucaptcha?
        redirect_to new_session_path, alert: ('验证码不正确或者已过期')
        return
      end
      true
    end

    def valify_phone_unrepeated!
      phonenumber = User.find_by_cellphone(params[:cellphone])

        unless phonenumber.nil?
        # flash[:notice] = '手机号已被注册了哦～'
        redirect_to new_user_path, alert: ('手机号已被注册了哦～可以登录试试看呢')
        return
        end
      true
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
end
