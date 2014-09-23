# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spree_conditional_promotion_actions/version'

Gem::Specification.new do |spec|
  spec.name          = "spree_conditional_promotion_actions"
  spec.version       = SpreeConditionalPromotionActions::VERSION
  spec.authors       = ["Isaac Freeman"]
  spec.email         = ["isaac@resolvedigital.co.nz"]
  spec.summary       = %q{A parent class and examples for Spree promotion actions that activate different methods when eligible and ineligible. A typical use case would be to add a promotional item to the cart if an order is eligible and remove it again if the order changes to become ineligible.}
  spec.description   = %q{A parent class and examples for Spree promotion actions that activate different methods when eligible and ineligible. A typical use case would be to add a promotional item to the cart if an order is eligible and remove it again if the order changes to become ineligible.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'minitest'
end
