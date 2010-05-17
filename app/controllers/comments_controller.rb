class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    thought = Thought.find(params[:thought_id])
    thought.comments.create(:user => current_user,
                            :content => params[:content])
    goto_user(thought.user)
  end
end
