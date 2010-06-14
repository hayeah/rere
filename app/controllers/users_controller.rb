class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:watch,:share]

  def stream
    @thought  = Thought.new
    if owner?
      @thoughts = current_user.stream
    else
      @thoughts = owner.thoughts.limit(25)
    end
  end

  def watch
    current_user.watch(owner)
    redirect_to stream_path(:username => owner.username)
  end

  def unwatch
    current_user.unwatch(owner)
    redirect_to stream_path(:username => owner.username)
  end

  def share
    current_user.share(params[:content])
    redirect_to stream_path(:username => current_user.username)
  end
end

