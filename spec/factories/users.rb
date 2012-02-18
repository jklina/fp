# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    name {"#{username}"}
    email { "#{username}@example.com" }
    password 'secret'
    password_confirmation 'secret'

    factory :normal_user do
      after_create { |u| Factory(:assignment, :user => u) }
    end

  end
end
