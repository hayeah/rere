class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  layout 'application'

  def goto_user(user)
    redirect_to :controller => :users, :action => :stream, :username => user.username
  end
end
