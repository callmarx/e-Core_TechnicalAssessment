# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.2"

###### BASIC FRAMEWORKS ######
# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

##### VIEWS/CONTROLLERS #####
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.12.0"

##### ADDITIONAL FUNCTIONS #####
# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "~> 1.18.3", require: false
# Library that allows you to use other API’s and provides responses from them.
gem "httparty", "~> 0.22.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", "~> 1.2024.1", platforms: %i[windows jruby]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "~> 1.9.2", platforms: %i[mri windows]
  # Ensure the database is in a clean state on every test.
  gem "database_cleaner-active_record", "~> 2.1"
  # Generate fake data for use in tests.
  gem "faker", "~> 3.4.1"
  # Generate models based on factory definitions.
  gem "factory_bot_rails", "~> 6.4.3"
  ### TO-DO: In addition to the foreman gem, create a bin/setup script to prepare
  ### the project for first use. Use as reference:
  ### https://github.com/rubyforgood/human-essentials/blob/main/bin/setup
  # Rails plugin for command line.
  gem "pry-rails", "~> 0.3.9"
  # Validate the JSON returned by your Rails JSON APIs
  gem "json_matchers", "0.11.1"
  # RSpec behavioral testing framework for Rails.
  gem "rspec-rails", "~> 6.1.2"
  # Show code coverage.
  gem "simplecov", "~> 0.22"
  # More concise test ("should") matchers
  gem "shoulda-matchers", "~> 6.2"
  # Static analysis / linter.
  gem "rubocop", "~> 1.64.1"
  gem "rubocop-packaging", "~> 0.5.2"
  gem "rubocop-performance", "~> 1.21.0"
  gem "rubocop-rails", "~> 2.24.1"
  gem "rubocop-rspec", "~> 2.29.1"
  gem "rubycritic", "~> 4.9"
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end
