class UsersController < ApplicationController
  include UsersHelper
  
  def stream
    @comment = Comment.new
    @thoughts = Thought.find(owner)
    pp Comment.db.keys
    pp @thoughts.first.comments
  end
end
  