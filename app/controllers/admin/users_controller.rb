class Admin::UsersController < ApplicationController
  layout 'admin'
  def index
    @users = User.order(id: 'desc')
  end

end
