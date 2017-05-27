class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_login

  helper_method :current_cart

  def current_cart
    @current_cart ||= find_cart
  end

  private

  def find_cart
    cart = Cart.find_by(id: session[:cart_id])
    if cart.blank?
      cart = Cart.create
    end
    session[:cart_id] = cart.id
    return cart
  end

  # def admin_required
  #   if !current_user.is_admin?
  #     redirect_to "/", alert: "You are not admin."
  #   end
  # end

  # 此为重写sorcery默认的 not_authenticated 方法（config/initializers/sorcery.rb），当用户未登录时，弹出提示，并且重新导向登录页面
  def not_authenticated
    flash[:warning] = 'You have to authenticate to access this page.'
    redirect_to new_session_path
  end


end
