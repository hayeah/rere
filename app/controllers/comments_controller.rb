class CommentsController < ApplicationController
  before_filter :authenticate_user!
  def create
    thought = Thought.find(params[:thought_id])
    thought.comments.create(:user => current_user,
                            :content => params[:content])
    if group_id = params[:group_id]
      goto_group(Group.find(group_id))
    elsif username = params[:username]
      goto_user(User.where(:username => username).first)
    else
      raise "dunno where to go"
    end
  end
end
