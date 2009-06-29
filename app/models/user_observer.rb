class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Mailer::deliver_confirmation_email(user)
  end
end
