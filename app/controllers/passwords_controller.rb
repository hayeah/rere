class PasswordsController < Devise::PasswordsController
  prepend_view_path "app/views/devise"
  layout "box"
end
