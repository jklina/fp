source 'http://rubygems.org'

gem 'rails', '3.1.3'
gem 'RedCloth', '4.2.7'
gem 'will_paginate', '~> 3.0'
gem 'paperclip', :git => 'git://github.com/thoughtbot/paperclip.git'
gem 'jquery-rails'
gem 'haml-rails'
gem 'twitter-text', '1.4.2'

group :test do
  gem 'rspec-rails'
  gem 'shoulda'
  gem 'capybara'
  gem 'launchy'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'database_cleaner'
  gem 'rb-fsevent', :require => false if RUBY_PLATFORM =~ /darwin/i
  gem 'rb-readline'
end

group :production do
  gem 'mysql2',  '>=0.3'
end

group :development do
  gem 'sqlite3', '1.3.4', :require => 'sqlite3'
end
