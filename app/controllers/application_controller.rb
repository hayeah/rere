class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery
  layout 'application'

  def goto_user(user)
    redirect_to stream_path(:username => user.username)
  end

  def goto_group(group)
    redirect_to group_path(:id => group.id)
  end
end
