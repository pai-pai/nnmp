source 'https://rubygems.org'

gem "rails", "~> 3.2.12"
gem "rails-i18n"
gem "jquery-rails"
gem "therubyracer"
#gem "kaminari"
gem "bcrypt-ruby", :require => "bcrypt"

group :production do
  gem "pg"
  gem "thin"
end

group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'bootstrap-sass', '~> 2.3.0.1'
  gem "coffee-rails", "~> 3.2.2"
  gem "uglifier", ">= 1.0.3"
end

group :development, :test do
    gem "sqlite3"
    gem "rspec-rails", "~> 2.13.0"
    gem "taps", "~> 0.3.24"
    gem "factory_girl_rails", "~> 4.2.1"#, :require => false
    gem "debugger"
end

group :development do
    gem "faker", "~> 1.1.2"
end

group :test do
    gem "capybara"
    gem "database_cleaner"
end

