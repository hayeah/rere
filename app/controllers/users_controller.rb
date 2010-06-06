class UsersController < ApplicationController
  before_filter :authenticate_user!, :only => [:watch,:share]

  STREAM_SIZE = 25
  def stream
    @thought  = Thought.new
    if owner?
      @thoughts = current_user.shared_stream.limit(STREAM_SIZE)
    else
      @thoughts = owner.stream.limit(STREAM_SIZE)
    end
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

