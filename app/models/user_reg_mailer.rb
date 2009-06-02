class UserRegMailer < ActionMailer::Base
 
  def confirmation_email(user, confirmation_url)
    # email header info MUST be added here
    @recipients = user.email
    @from = "robot@pixelfuckers.org"
    @subject = "Confirm email address"

    # email body substitutions go here
    @body["username"] = user.name
    @body["confirmation_url"] = confirmation_url
  end
 
end
