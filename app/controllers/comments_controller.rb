class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    thought = Thought.find(params[:thought_id])
    thought.comment(current_user,params[:content])
    if params[:goto_url]
      redirect_to params[:goto_url]
    else
      raise "dunno where to go"
    end
  end
end
