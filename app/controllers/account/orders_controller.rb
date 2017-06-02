class Account::OrdersController < ApplicationController
  before_action :require_login
  def index
    @orders = current_user.orders.order("created_at DESC")
  end
end
