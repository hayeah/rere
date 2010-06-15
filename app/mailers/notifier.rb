class Notifier < ActionMailer::Base
  include ApplicationHelper
  default :from => "no-reply@reremind.me"

  def new_user(user)
    @user = user
    mail(:subject => "Welcome to Reremind",
         :to => user.email,
         :bcc => ["Howard Yeh <hayeah@gmail.com>"]) do |format|
      format.text
    end
  end
end
