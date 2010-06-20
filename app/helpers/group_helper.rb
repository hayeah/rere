module GroupHelper
  def link_to_join(group)
    unless group.include?(current_user)
      button_to("join", {:action => :join, :id => group.id})
    end
  end
end
