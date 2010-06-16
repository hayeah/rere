class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:watch,:share]

  def stream
    @thought  = Thought.new
    if owner?
      @thoughts = current_user.stream
    else
      @thoughts = owner.thoughts.limit(25).order("id desc")
    end
  end

  def follow
    current_user.follow(owner)
    redirect_to stream_path(:username => owner.username)
  end

  def unfollow
    current_user.unfollow(owner)
    redirect_to stream_path(:username => owner.username)
  end

  def share
    thought = current_user.share(params[:content])
    
    redirect_to stream_path(:username => current_user.username)
  end
end

