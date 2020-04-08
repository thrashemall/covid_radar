source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

gem 'rails', '6.0.2.2'
gem 'pry-rails'
gem 'puma'
gem 'gruff'
gem 'dotenv-rails'
gem 'sentry-raven'
gem 'slack-notifier'

# transport
gem 'faraday'
gem 'typhoeus'
gem 'faraday_middleware'
gem 'telegram-bot-ruby', require: 'telegram/bot'

# background
gem 'sidekiq'
gem 'sidekiq-scheduler'

# db
gem 'pg'
gem 'activerecord-import'
gem 'redis'
gem 'with_advisory_lock'

group :development, :test do
  gem 'rspec-rails'
end

group :development do
  gem 'mina'
  gem 'annotate'
  gem 'listen', '>= 3.0.5', '< 3.2'
end

group :test do
  gem 'factory_bot'
  gem 'ffaker'
  gem 'shoulda-matchers'
  gem 'webmock'
  gem 'vcr'
end

