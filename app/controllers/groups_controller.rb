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
    render :layout => "application"
  end

  def share
    @group = Group.find(params[:id])
    @thought = @group.share(params[:content],current_user)
    unless request.xhr?
      to_show
    else
      render "thoughts/share"
    end
  end

  def join
    @group = Group.find(params[:id])
    @group.join(current_user)
    to_show
  end

  private
  def to_show
    redirect_to :action => :show, :permalink => @group.permalink
  end
end
