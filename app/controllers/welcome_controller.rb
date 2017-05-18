class WelcomeController < ApplicationController

  layout false
  
  def index
    @liang = "黄鸿亮"
    flash[:notice] = "haha"
  end
end
