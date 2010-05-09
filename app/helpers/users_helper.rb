module UsersHelper
  def user_is_owner?
    current_user && (current_user == owner)
  end

  def owner
    @owner ||= User.where(:username => params[:username]).first
  end
end
