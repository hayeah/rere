module GroupHelper
  def link_to_join
    unless Group.member?(@group.id,current_user.id)
      link_to("join", {:action => :join, :id => @group.id}, :method => :post)
    end
  end

  def group
    @group
  end
end
