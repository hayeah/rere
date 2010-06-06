class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"
  layout "box"
end
