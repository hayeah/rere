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
  end
end
