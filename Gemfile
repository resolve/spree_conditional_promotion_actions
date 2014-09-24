source 'https://rubygems.org'

gem 'spree', github: 'spree/spree', branch: '2-2-stable'
# Provides basic authentication functionality for testing parts of your engine
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-2-stable'

group :test, :development do
  platforms :ruby_19 do
    gem 'pry-debugger'
  end
  platforms :ruby_20, :ruby_21 do
    gem 'pry-byebug'
  end
  gem 'rspec-retry'
end

gemspec
