module GroupHelper
  def link_to_join(group)
    unless group.include?(current_user)
      link_to("join", {:action => :join, :id => group.id}, :method => :post)
    end
  end
end
