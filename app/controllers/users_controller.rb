class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    @comment = Comment.new
    @thoughts = Thought.find(owner)
    p @thoughts
  end
end
