Factory.define(:announcement) do |a|
  a.title       { Faker::Lorem.sentence.chomp(".") }
  a.body        { Faker::Lorem.sentences.join(" ") }
  a.association :user
end

Factory.define(:category) do |c|
  c.title       { Faker::Lorem.sentence.chomp(".") }
  c.description { Faker::Lorem.sentences.join(" ") }
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

Factory.define(:static_page) do |p|
  p.title { Faker::Lorem.sentence.chomp(".") }
  p.body  { Faker::Lorem.sentences.join(" ") }
  p.slug  { |s| s.title.parameterize }
end

Factory.define(:topic) do |t|
  t.title       { Faker::Lorem.sentence.chomp(".") }
  t.content     { Faker::Lorem.sentences.join(" ") }
  t.view        0
  t.association :forum
  t.association :user
end

Factory.define :user do |f|
  f.username "foo"
  f.password "foobar"
  f.password_confirmation { |u| u.password }
  f.email "foo@foobar.com"
end
