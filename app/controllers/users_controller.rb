class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    @comment = Comment.new
    @thoughts = Thought.find(owner)
  end

  def follow
    if owner != current_user
      Following.create(owner,current_user)
    end
    redirect_to stream_path(:username => owner.username)
  end
end
  
