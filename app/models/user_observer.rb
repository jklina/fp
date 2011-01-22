class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Mailer.confirmation_email(user).deliver
  end
end
