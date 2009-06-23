class Mailer < ActionMailer::Base
  def confirmation_email(user, confirmation_url)
    @recipients = user.email
    @from = "robot@pixelfuckers.org"
    @subject = "Activating your PF account"

    @body["name"] = user.name
    @body["confirmation_url"] = confirmation_url
  end
end
