source 'http://rubygems.org'

# Rails 3.1, Asset Pipeline and Javascript
gem 'rails', '3.1.0'
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end
gem 'jquery-rails'

# Required to give an executable JS environment 
# in Production on Heroku
group :production do
  gem 'therubyracer-heroku', '0.8.1.pre3'
end

# Development / Test only.
group :development, :test do
  gem 'ruby-debug'
end
group :test do
  gem 'turn', :require => false
end

# Squish Application Dependancies
gem "couchbase-ruby-client", :require => "couchbase"
gem "validate_url"


