class PaymentsController < ApplicationController

  protect_from_forgery except: [:pay_return, :pay_notify]
  before_action :auth_user, except: [:pay_return, :pay_notify]
  before_action :auth_request, only: [:pay_return, :pay_notify]

  def index
    @order = current_user.orders.find_by_token(params[:order_token])
    @payment = current_user.payments.find_by_payment_no(params[:payment_no])
    if @order.present? && @payment.present? && @order.payment = @payment
      true
    elsif @order.is_paid?
      redirect_to root_path, warning: "该订单已支付！"
    else
      redirect_to root_path, alert: "该订单或支付号不存在，请重新下单~！"
    end
  end

  def create_payment
    payment = current_user.payments.find_by_payment_no(params[:payment_no])
    if payment.present? && payment.status == "initial"
      pay_options = {
        "service" => 'create_direct_pay_by_user',
        "partner" => ENV["alipay_pid"],
        "seller_id" => ENV["alipay_pid"],
        "payment_type" => "1",
        "pay_type" => "1",
        "notify_url" => "",
        "return_url" => "",
        "anti_phishing_key" => "",
        "exter_invoke_ip" => "",
        "out_trade_no" => payment.payment_no,
        "subject" => "商店大赛加油站",
        "total_fee" => payment.total_money,
        "body" => "商店大赛加油站",
        "_input_charset" => "utf-8",
        "sign_type" => 'MD5',
        "sign" => "",
        "page" => "3"
      }
      pay_options.merge!("sign" => build_generate_sign(pay_options))
      body = RestClient.get ENV["alipay_url"] + "?" + pay_options.to_query
      pay_qr = JSON.parse(body)["qr"]
      order_id = JSON.parse(body)["order_id"]
      @qr = RQRCode::QRCode.new(pay_qr, :size => 6, :level => :h )
    render :json => { :test7 => '<%= rucaptcha_image_tag %>', :qrcode => @qr.as_html, :order_id => order_id, :status => "ok", payment_no: payment.payment_no, price: payment.total_money }
    else
      render :json => { :status => "支付号已支付或不存在，请重新生成支付" }
    end
  end

  def get_payment_status
    body2 = RestClient.get ENV["alipay_is_paid_url"] + { id: ENV["alipay_pid"], order_id: @raw_order, token: ENV["require_token"] }.to_query
    order_status = JSON.parse(body2)["status"]
  end

  def pay_return
    do_payment_test
  end

  def pay_notify
    do_payment_test
  end

  def test
    body2 = RestClient.get ENV["alipay_is_paid_url"] + {
      id: ENV["alipay_pid"],
      order_id: params[:order],
      token: ENV["require_token"],
      call: ""
    }.to_query
    order_status = JSON.parse(body2)["status"]
    render :json => { :liang => order_status }
  end

  def success

  end

  def failed

  end

  def lesson_generat_pay
    payment = Payment.lesson_order_create!(params)
    redirect_to create_payment_payment_path(payment_no: payment.payment_no, id: payment.id)
  end

  def generate_pay
    @order = current_user.orders.find_by_token(params[:id])
    payment_no = @order.generate_pay!(current_user)
    redirect_to payments_path(payment_no: payment_no, order_token: @order.token)
  end

  private

  def is_payment_success?
    !params[:trade_no].nil?
  end

  def update_status
    @payment = Payment.find_by_payment_no(params[:out_trade_no])
    redirect_to root_path
  end

  def do_payment_test
    @payment = Payment.find_by_payment_no(params[:out_trade_no])
    unless @payment.is_success?
      if is_payment_success?
        ChinaSMS.use :yunpian, password: ENV["sms_pay"]
        if @payment.user.is_overseas?
          ChinaSMS.to @payment.user.cellphone, "【大赛加油站】您已成功支付，感谢支持！可进入个人订单查看详情。希望能成为您10票中的1票：http://t.cn/RSSdARt"
        else
          ChinaSMS.to @payment.user.cellphone, "【大賽加油站】您已成功支付，感謝支持！可進入個人訂單查看詳情。希望能成為您10票中的1票：http://t.cn/RSSdARt"
        end
        @payment.do_success_payment! params
        render :json => "ok"
      else
        @payment.do_failed_payment! params
      end
    end
  end

  def auth_request
    option = params.to_hash
    if option["code"] != ENV["alipay_code_key"]
      redirect_to failed_payments_path
    end
  end

  def build_generate_sign options
    sign_data = build_sign_data(options.dup)
    Digest::MD5.hexdigest(sign_data + ENV["alipay_md5_secret"])
  end

  def build_sign_data data_hash
    data_hash.delete_if { |k, v| k == "sign_type" || k == "sign" || v.blank? }
    data_hash.to_a.map { |x| x.join('=') }.sort.join('&')
  end

end
