class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index

  def index
    if user_signed_in?
      redirect_to stream_path(:username => current_user.username)
    else
      @user = User.new
      render "splash", :layout => "box"
    end
  end
end
