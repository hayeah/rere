class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    
  end

  def watch
    current_user.watch(owner)
    redirect_to stream_path(:username => owner.username)
  end
end
  
