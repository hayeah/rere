class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"
  layout "box"

  def create
    super
    if resource.valid?
      Notifier.new_user(resource).deliver
    end
  end

  def update
    if resource.update_with_password(params[resource_name])
      set_flash_message :notice, :updated
      redirect_to :action => :edit
    else
      clean_up_passwords(resource)
      resource.reload
      render :edit
    end
  end
end
