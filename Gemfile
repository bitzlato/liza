# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.3'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 5.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'hiredis', '~> 0.6.1'
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'aasm', '~> 5.0.8'
gem 'active_link_to'
gem 'auto_logger'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'enumerize'
gem 'env-tweaks', '~> 1.0.0'
gem 'jwt', github: 'jwt/ruby-jwt'
gem 'jwt-multisig', '~> 1.0.0'
gem 'jwt-rack', '~> 0.1.0', require: false
gem 'memoist'
gem 'pagy'
gem 'premailer-rails'
gem 'ransack', github: 'activerecord-hackery/ransack'
gem 'settingslogic'
gem 'simple_form'
gem 'slim-rails'
gem 'sidekiq'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rubocop-rails'
end

group :development do
  gem 'foreman'
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 4.1.0'
  # Display performance information such as SQL time and flame graphs for each request in your browser.
  # Can be configured to work on production as well see: https://github.com/MiniProfiler/rack-mini-profiler/blob/master/README.md
  gem 'listen', '~> 3.3'
  gem 'rack-mini-profiler', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 3.26'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

gem 'gravatarify', '~> 3.1'
gem 'semver2', '~> 3.4'
gem 'title', '~> 0.0.8'

gem 'draper', '~> 4.0'

gem "bugsnag", "~> 6.20"

gem "kaminari", "~> 1.2"

gem "rails-i18n", "~> 6.0"

gem "rubyzip", "~> 2.3"

gem "caxlsx", "~> 3.0"
gem 'caxlsx_rails'

gem "simple_form_extension", "~> 1.4"
gem 'redactor-rails', github: 'glyph-fr/redactor-rails'

gem "coffee-rails", "~> 5.0"

gem "carrierwave", "~> 2.2"
