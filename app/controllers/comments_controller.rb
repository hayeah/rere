class CommentsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    Comment.save(params[:thought_id],current_user,params[:content])
    redirect_to :controller => :users, :action => :stream, :username => params[:username]
  end
end
