class GroupsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end

  def create
    Group.create(params[:group].merge("creator_id" => current_user))
  end

  def show
    @group = Group.find(params[:id])
    # @thoughts = Thought.of_group(group_id)
  end

  def say
    Group::Thought.create(params[:id],current_user,params[:content])
    to_show
  end

  def join
    Group.join(params[:id],current_user.id)
    to_show
  end

  private
  def to_show
    redirect_to :action => :show, :id => params[:id]
  end
end
