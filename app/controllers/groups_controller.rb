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
  end

  def join
    Group.join(params[:id],current_user.id)
    redirect_to :action => :show, :id => params[:id]
  end
end
