require 'test_helper'

class MailerTest < ActionMailer::TestCase
  context "Calling confirmation_email" do
    setup do
      ActionMailer::Base.deliveries.clear
      @user  = Factory(:user)
      @email = Mailer.confirmation_email(@user).deliver
    end

    should "queue a message for delivery" do
      assert ActionMailer::Base.deliveries.any?
    end

    should "produce a message that contains information relevant to the user" do
      assert_equal ["robot@pixelfuckers.org"], @email.from
      assert_equal [@user.email], @email.to
      assert_equal "Activating your PF account", @email.subject
      assert_match /#{@user.name}/, @email.encoded
      assert_match /#{@user.confirmation_token}/, @email.encoded
    end
  end
end
