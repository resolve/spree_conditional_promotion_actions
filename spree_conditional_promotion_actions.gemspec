# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_conditional_promotion_actions'
  s.version     = '0.0.1'
  s.summary     = 'A parent class and examples for Spree promotion actions that activate different methods when eligible and ineligible. A typical use case would be to add a promotional item to the cart if an order is eligible and remove it again if the order changes to become ineligible.'
  s.description = 'A parent class and examples for Spree promotion actions that activate different methods when eligible and ineligible. A typical use case would be to add a promotional item to the cart if an order is eligible and remove it again if the order changes to become ineligible.'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Isaac Freeman'
  s.email     = 'isaac@resolvedigital.co.nz'
  s.homepage  = 'http://resolve.digital'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.2.5'

  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
