require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "The User class" do
    setup do
      @password = Faker::Lorem.words.join("")
      @user = Factory(:user, :password => @password, :password_confirmation => @password)
    end

    should     allow_mass_assignment_of(:name)
    should     allow_mass_assignment_of(:location)
    should     allow_mass_assignment_of(:country)
    should     allow_mass_assignment_of(:email)
    should     allow_mass_assignment_of(:aim)
    should     allow_mass_assignment_of(:msn)
    should     allow_mass_assignment_of(:icq)
    should     allow_mass_assignment_of(:yahoo)
    should     allow_mass_assignment_of(:website)
    should     allow_mass_assignment_of(:current_projects)
    should     allow_mass_assignment_of(:username)
    should     allow_mass_assignment_of(:time_zone)
    should     allow_mass_assignment_of(:photo)
    should     allow_mass_assignment_of(:banner)
    should_not allow_mass_assignment_of(:id)
    should_not allow_mass_assignment_of(:last_login_time)
    should_not allow_mass_assignment_of(:access_level)
    should_not allow_mass_assignment_of(:password_salt)
    should_not allow_mass_assignment_of(:password_hash)
    should_not allow_mass_assignment_of(:confirmation_token)
    should_not allow_mass_assignment_of(:user_rating)
    should_not allow_mass_assignment_of(:user_rating_lower_bound)
    should_not allow_mass_assignment_of(:user_rating_upper_bound)
    should_not allow_mass_assignment_of(:admin_rating)
    should_not allow_mass_assignment_of(:admin_rating_lower_bound)
    should_not allow_mass_assignment_of(:admin_rating_upper_bound)
    should_not allow_mass_assignment_of(:confirmed)
    should_not allow_mass_assignment_of(:authentication_token)
    should_not allow_mass_assignment_of(:photo_file_name)
    should_not allow_mass_assignment_of(:photo_content_type)
    should_not allow_mass_assignment_of(:photo_file_size)
    should_not allow_mass_assignment_of(:photo_updated_at)
    should_not allow_mass_assignment_of(:banner_file_name)
    should_not allow_mass_assignment_of(:banner_content_type)
    should_not allow_mass_assignment_of(:banner_file_size)
    should_not allow_mass_assignment_of(:banner_updated_at)
    should_not allow_mass_assignment_of(:created_at)
    should_not allow_mass_assignment_of(:updated_at)

    should have_many(:authorships)
    should have_many(:submissions).through(:authorships)
    should have_many(:reviews).dependent(:destroy)
    should have_many(:features)
    should have_many(:announcements)
    should have_many(:topics)
    should have_many(:posts)
    should have_many(:remarks).dependent(:destroy)
    should have_many(:comments).dependent(:destroy)

    should validate_presence_of(:username)
    should validate_presence_of(:email)
    should validate_presence_of(:username)

    should validate_uniqueness_of(:username).case_insensitive
    should validate_uniqueness_of(:email).case_insensitive

    should validate_format_of(:email).with(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/)

    should "return the user when authenticating with a valid username and password combination" do
      assert_equal @user, User.authenticate(@user.username, @password)
    end

    should "return nil when authenticating with an invalid username and password combination" do
      assert_nil User.authenticate(@user.username, @password.reverse)
    end

    should "set the user's confirmed attribute to true when confirming with a good token" do
      assert !@user.confirmed
      User.confirm(@user.confirmation_token)
      @user.reload
      assert @user.confirmed
    end

    should "not return nil when confirming with a bad token" do
      assert_nil User.confirm("not-a-proper-token")
    end

    should "wrap the SHA256 digest algorithm" do
      string = "text"
      assert_equal Digest::SHA256.hexdigest(string), User.encrypt(string)
    end
  end

  context "A User instance" do
    context "that's been saved" do
      setup do
        @user = Factory(:user)
      end

      should "require a password if password_confirmation is present" do
        @user.password = nil
        @user.password_confirmation = "passw"
        assert @user.errors[:password]
      end

      should "require a password_confirmation if password is present" do
        @user.password = "passw"
        @user.password_confirmation = nil
        assert @user.errors[:password_confirmation]
      end

      should "ensure password and password_confirmation match if both are present" do
        password = Faker::Lorem.words.join("")
        @user.password = @user.password_confirmation = password
        assert @user.valid?
        @user.password_confirmation = password.reverse
        assert !@user.valid?
      end

      should "require passwords to be at least five characters long if present" do
        @user.password = @user.password_confirmation = "pass"
        assert @user.errors[:password]
        @user.password = @user.password_confirmation = "passw"
        assert @user.valid?
      end

      should "not require a password to update" do
        @user.password = @user.password_confirmation = nil
        @user.username = Faker::Internet.user_name
        assert @user.save
      end

      should "not change password_hash if not updating password" do
        old_password_hash = @user.password_hash
        @user.username = Faker::Internet.user_name
        assert @user.save
        @user.reload
        assert_equal old_password_hash, @user.password_hash
      end

      should "change password_hash if updating password" do
        old_password_hash = @user.password_hash
        @user.password = @user.password_confirmation = Faker::Lorem.words.join("")
        assert @user.save
        @user.reload
        assert_not_equal old_password_hash, @user.password_hash
      end

      should "not change password_salt when updating" do
        old_password_salt = @user.password_salt
        @user.username = Faker::Internet.user_name
        assert @user.save
        @user.reload
        assert_equal old_password_salt, @user.password_salt
        @user.password = @user.password_confirmation = Faker::Lorem.words.join("")
        assert @user.save
        @user.reload
        assert_equal old_password_salt, @user.password_salt
      end

      should "produce its parameterized username when calling to_param" do
        assert_equal @user.username.parameterize, @user.to_param
      end

      should "set authentication_token when calling remember" do
        assert @user.authentication_token.blank?
        assert @user.remember
        assert @user.authentication_token.present?
      end

      should "nilify authentication_token when calling forget" do
        assert @user.remember
        assert @user.authentication_token.present?
        assert @user.forget
        assert @user.authentication_token.blank?
      end

      should "provide produce admin ratings on submissions when calling admin_ratings" do
        ratings = [ [ 85, 92 ], [ 93, 87 ] ]

        ratings.each do |rs|
          @submission = Factory(:submission)
          @submission.users << @user

          rs.each do |rating|
            review = Factory(:review, :rating => rating, :submission => @submission)
            review.by_administrator = true
            review.save!
          end
        end

        @user.reload
        assert_equal [ 85, 92, 93, 87 ], @user.admin_ratings
      end

      should "provide produce user ratings on submissions when calling user_ratings" do
        ratings = [ [ 81, 95 ], [ 88, 97 ] ]

        ratings.each do |rs|
          @submission = Factory(:submission)
          @submission.users << @user

          rs.each do |rating|
            review = Factory(:review, :rating => rating, :submission => @submission)
            review.save!
          end
        end

        @user.reload
        assert_equal [ 81, 95, 88, 97 ], @user.user_ratings
      end

      # Testing indirectly, as the creation of a review changes a user's statistics.
      should "update statistics when calling update_statistics!" do
        @submission = Factory(:submission)
        @submission.users << @user

        old_admin_rating             = @user.admin_rating
        old_admin_rating_lower_bound = @user.admin_rating_lower_bound
        old_admin_rating_upper_bound = @user.admin_rating_upper_bound
        old_user_rating              = @user.user_rating
        old_user_rating_lower_bound  = @user.user_rating_lower_bound
        old_user_rating_upper_bound  = @user.user_rating_upper_bound


        [ 83, 98, 93 ].each do |rating|
          review = Factory.build(:review, :rating => rating, :submission => @submission)
          review.save!
          @user.reload
        end

        [ 85, 90, 95 ].each do |rating|
          review = Factory.build(:review, :rating => rating, :submission => @submission)
          review.by_administrator = true
          review.save!
          @user.reload
        end

        assert_not_equal old_admin_rating,             @user.admin_rating
        assert_not_equal old_admin_rating_lower_bound, @user.admin_rating_lower_bound
        assert_not_equal old_admin_rating_upper_bound, @user.admin_rating_upper_bound
        assert_not_equal old_user_rating,              @user.user_rating
        assert_not_equal old_user_rating_lower_bound,  @user.user_rating_lower_bound
        assert_not_equal old_user_rating_upper_bound,  @user.user_rating_upper_bound
      end
    end

    context "that hasn't been saved" do
      setup do
        @user = Factory.build(:user)
      end

      should "require a password" do
        @user.password = nil
        assert @user.errors[:password]
      end

      should "require a password_confirmation" do
        @user.password_confirmation = nil
        assert @user.errors[:password_confirmation]
      end

      should "ensure password and password_confirmation match" do
        password = Faker::Lorem.words.join("")
        @user.password = @user.password_confirmation = password
        assert @user.valid?
        @user.password_confirmation = password.reverse
        assert !@user.valid?
      end

      should "require passwords to be at least five characters long" do
        @user.password = @user.password_confirmation = "pass"
        assert @user.errors[:password]
        @user.password = @user.password_confirmation = "passw"
        assert @user.valid?
      end

      should "set password_salt after saving" do
        assert @user.password_salt.blank?
        assert @user.save
        assert @user.password_salt.present?
      end

      should "set password_hash after saving" do
        assert @user.password_hash.blank?
        assert @user.save
        assert @user.password_hash.present?
      end

      should "set confirmation_token after saving" do
        assert @user.confirmation_token.blank?
        assert @user.save
        assert @user.confirmation_token.present?
      end
    end
  end
end
