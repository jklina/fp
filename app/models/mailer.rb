class Mailer < ActionMailer::Base
  def confirmation_email(user)
    @recipients = user.email
    @from = "robot@pixelfuckers.org"
    @subject = "Activating your PF account"

    @body["name"] = user.name
    @body["confirmation_url"] = url_for(:controller => "users", :action => "confirm", :token => user.confirmation_token, :only_path => false)
  end
end
