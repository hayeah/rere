class GroupsController < ApplicationController
  before_filter :authenticate_user!
  def index
    @groups = Group.all
  end
  
  def new
    @group = Group.new
  end

  def create
    @group = Group.create(params[:group].merge("creator_id" => current_user))
    params[:id] = @group.id
    to_show
  end

  def show
    @group = Group.find(params[:id])
    @thoughts = Group::Thought.find(@group.id)
  end

  def say
    Group::Thought.create(params[:id],current_user,params[:content])
    to_show
  end

  # {"commit"=>"Comment",
  #   "authenticity_token"=>"R1vhauI/3hrPVqyW0Cp1Xj/DTCAq7ISZwfj7D/oEfDM=",
  #   "group_id"=>"1",
  #   "content"=>"awef",
  #   "thought_id"=>"6"}
  
  def comment
    Group::Comment.create(params[:thought_id],current_user,params[:content])
    params[:id] = params[:group_id]
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
