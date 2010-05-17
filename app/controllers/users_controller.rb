class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    @thought  = Thought.new
    @thoughts = owner.thoughts.order("id desc")
  end

  def watch
    current_user.watch(owner)
    redirect_to stream_path(:username => owner.username)
  end

  def share
    current_user.share(params[:content])
    redirect_to stream_path(:username => current_user.username)
  end
end

