module ApplicationHelper
  def production?
    Rails.env == "production"
  end
  
  def user_is_owner?
    current_user && (current_user == owner)
  end

  def owner?
    current_user && (current_user == owner)
  end

  def owner
    @owner ||= User.where(:username => params[:username]).first
  end

  def link_to_user(user)
    link_to(user.username, stream_path(:username => user.username))
  end

  def parent_layout(layout)
    @content_for_layout = self.output_buffer
    self.output_buffer = render(:file => "layouts/#{layout}")
  end
  
  def errorarrow
    image_tag "/images/error_arrow.png"
  end
end
