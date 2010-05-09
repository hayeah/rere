class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index

  # tweet stream
  def index
    if user_signed_in?
      redirect_to stream_path(:username => current_user.username)
    else
      render
    end
  end
end
