Factory.define(:announcement) do |a|
  a.title       { Faker::Lorem.sentence.chomp(".") }
  a.body        { Faker::Lorem.sentences.join(" ") }
  a.association :user
end

Factory.define(:authorship) do |a|
  a.association :submission
  a.association :user
end

Factory.define(:category) do |c|
  c.title       { Faker::Lorem.sentence.chomp(".") }
  c.description { Faker::Lorem.sentences.join(" ") }
end

Factory.define(:comment) do |c|
  c.body        { Faker::Lorem.sentences.join(" ") }
  c.association :user
  c.association :commentable, :factory => :submission # Using the obvious example here.
end

Factory.define(:feature) do |f|
  f.title       { Faker::Lorem.sentence.chomp(".") }
  f.comment     { Faker::Lorem.sentences.join(" ") }
  f.preview     File.new(File.join(Rails.root, "test", "fixtures", "files", "submission.png"))
  f.association :user
end

Factory.define(:featuring) do |f|
  f.association :feature
  f.association :submission
end

Factory.define(:forum_group) do |f|
  f.title  { Faker::Lorem.sentence.chomp(".") }
  f.weight { rand(101) }
end

Factory.define(:forum) do |f|
  f.title       { Faker::Lorem.sentence.chomp(".") }
  f.description { Faker::Lorem.sentences.join(" ") }
  f.weight      { rand(101) }
  f.association :forum_group
end

Factory.define(:post) do |p|
  p.content     { Faker::Lorem.sentences.join(" ") }
  p.association :forum
  p.association :topic
  p.association :user
end

Factory.define(:review) do |r|
  r.rating           { rand(100) + 1 }
  r.by_administrator false
  r.association      :submission
  r.association      :user
end

Factory.define(:static_page) do |p|
  p.title { Faker::Lorem.sentence.chomp(".") }
  p.body  { Faker::Lorem.sentences.join(" ") }
  p.slug  { |s| s.title.parameterize }
end

Factory.define(:submission) do |s|
  s.title        { Faker::Lorem.sentence.chomp(".") }
  s.description  { Faker::Lorem.sentences.join(" ") }
  s.association  :category
  s.preview      File.new(File.join(Rails.root, "test", "fixtures", "files", "submission.png"))
  s.after_build  { |submission| submission.users << Factory.create(:user) }
  s.after_create { |submission| submission.users << Factory.create(:user) }
end

Factory.define(:topic) do |t|
  t.title       { Faker::Lorem.sentence.chomp(".") }
  t.content     { Faker::Lorem.sentences.join(" ") }
  t.view        0
  t.association :forum
  t.association :user
end

Factory.define(:user) do |u|
  u.username              { Faker::Internet.user_name }
  u.email                 { Faker::Internet.email }
  u.password              { Faker::Lorem.words.join("") }
  u.password_confirmation { |s| s.password }
end
