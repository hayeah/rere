class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    @comment = Comment.new
    if !user_is_owner?
      @thoughts = Thought.find(owner)
    else
      @thoughts = Thought.public(current_user)
    end
  end

  def follow
    if owner != current_user
      Following.create(owner,current_user)
    end
    redirect_to stream_path(:username => owner.username)
  end

  def comment
    Comment.save(params[:thought_id],current_user,params[:content])
    redirect_to :action => :stream, :username => params[:username]
  end
end
  
