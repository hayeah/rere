class CommentsController < ApplicationController
  def create
    thought = Thought.find(params[:thought_id])
    Comment.new(params[:comment].merge(:thought => thought,:user => current_user)).save!
    redirect_to :controller => :users, :action => :stream, :username => current_user.username
  end
end
