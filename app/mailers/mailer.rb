class Mailer < ActionMailer::Base
  default :from => "robot@pixelfuckers.org"
  
  def confirmation_email(user)
    @recipients = user.email
    @subject = "Activating your PF account"

    @name = user.name
    @confirmation_url = url_for(:controller => "users", :action => "confirm", :token => user.confirmation_token, :only_path => false)
    mail(:to => @recipients, :subject => @subject)
  end
end
