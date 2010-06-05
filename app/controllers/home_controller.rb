class HomeController < ApplicationController
  before_filter :authenticate_user!, :except => :index

  # tweet stream
  def index
    if user_signed_in?
      render "splash"
    else
      @user = User.new
      render "splash"
    end
  end
end
