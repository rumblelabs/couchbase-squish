source 'http://rubygems.org'

gem 'rails', '3.1.0'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem "couchbase-ruby-client", :git => "git://github.com/couchbase/couchbase-ruby-client.git", :require => "couchbase"
gem "validate_url"
gem "couchbase-ruby-client", :require => "couchbase"
# gem "couchbase-ruby-client", :path => "~/active/couchbase-ruby-client", :require => "couchbase"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :development do
  gem 'ruby-debug'
end

group :test do
  # Pretty printed test output
  gem 'turn', :require => false
end

group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
end