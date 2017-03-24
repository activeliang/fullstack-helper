class WelcomeController < ApplicationController

  def index
    flash[:notice] = "haha"
  end
end
