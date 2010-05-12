module ApplicationHelper
  def user_is_owner?
    current_user && (current_user == owner)
  end

  def owner
    @owner ||= User.where(:username => params[:username]).first
  end

  def link_to_user(user)
    link_to(user.name, :controller => :users, :action => :stream, :username => user.username)
  end
end
