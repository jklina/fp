Factory.define(:announcement) do |a|
  a.title       { Faker::Lorem.sentence.chomp(".") }
  a.body        { Faker::Lorem.sentences.join(" ") }
  a.association :user
end

Factory.define :user do |f|
  f.username "foo"
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.email "foo@foobar.com"
end