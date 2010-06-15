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
    else
      clean_up_passwords(resource)
    end
    render :edit
  end
end
