class GroupsController < ApplicationController
  layout "box"
  before_filter :authenticate_user!
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end

  def create
    group = Group.make(params[:group].merge(:creator => current_user))
    params[:id] = group.id
    to_show
  end

  def show
    @group = Group.where(:permalink => params[:permalink]).first
    @thoughts = @group.stream
  end

  def share
    @group = Group.find(params[:id])
    current_user.share(params[:content],@group)
    to_show
  end

  def comment
    Group::Comment.create(params[:thought_id],current_user,params[:content])
    params[:id] = params[:group_id]
    to_show
  end

  def join
    @group = Group.find(params[:id])
    @group.join(current_user)
    to_show
  end

  private
  def to_show
    redirect_to :action => :show, :id => params[:id]
  end
end
