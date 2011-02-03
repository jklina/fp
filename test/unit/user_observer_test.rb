require 'test_helper'

class UserObserverTest < ActiveSupport::TestCase
  context "The UserObserver class" do
    setup do
      ActionMailer::Base.deliveries.clear
      @user = Factory.build(:user)
    end

    should "deliver an email when calling after_create with a user" do
      assert ActionMailer::Base.deliveries.empty?
      UserObserver.instance.after_create(@user)
      assert ActionMailer::Base.deliveries.any?
    end
  end
end
