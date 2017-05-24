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

    token = generate_cellphone_token
    VerifyToken.upsert params[:cellphone], token
    SendSMS.send params[:cellphone], "#{token} 验证码，注册"
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
