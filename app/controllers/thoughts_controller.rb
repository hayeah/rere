class ThoughtsController < ApplicationController
  before_filter :authenticate_user!, :except => :show
  def show
    @thought = Thought.find(params[:id],:include => [{:comments => :user},:user])
    render :layout => "box"
  end
end
