class ThoughtsController < ApplicationController
  before_filter :authenticate_user!
  def create
    Thought.save(current_user,params[:content])
    redirect_to :controller => :users, :action => :stream, :username => current_user.username
  end
end
