class GroupsController < ApplicationController
  layout "box"
  before_filter :authenticate_user!, :except => [:index,:show]
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end

  def create
    @group = Group.make(params[:group].merge(:creator => current_user))
    if @group.valid?
      to_show
    else
      render :action => :new
    end
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

  def leave
    @group = Group.find(params[:id])
    @group.remove(current_user)
    to_show
  end

  def join
    @group = Group.find(params[:id])
    @group.add(current_user)
    to_show
  end

  private
  def to_show
    redirect_to :action => :show, :permalink => @group.permalink
  end
end
