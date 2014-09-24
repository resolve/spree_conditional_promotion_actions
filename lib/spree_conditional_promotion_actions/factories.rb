FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_conditional_promotion_actions/factories'

  factory :use_conditional_action, class: Spree::Promotion::Rules::UseConditionalAction do
    promotion
  end
  factory :free_shipping, class: Spree::Promotion::Actions::FreeShipping

  # Note that we wouldn't instantiate ConditionalPromotionAction in normal use.
  # This is just to test that it can raise errors to say "Don't instantiate me."
  factory :conditional_promotion_action, class: Spree::Promotion::Actions::ConditionalPromotionAction
  factory :conditional_add_line_items, class: Spree::Promotion::Actions::ConditionalAddLineItems
  factory :conditional_free_shipping, class: Spree::Promotion::Actions::ConditionalFreeShipping do
    promotion
  end

  factory :supplement_size_option_type, class: Spree::OptionType do
    name 'Supplement Sizes'
    presentation 'Size'
    after(:create) do |option_type|
      option_type.option_values << build(:five_servings)
      create(:option_value, name: '30 Servings', presentation: '30 Servings', option_type: option_type)
      create(:option_value, name: '60 Servings', presentation: '60 Servings', option_type: option_type)
      create(:option_value, name: '120 Servings', presentation: '120 Servings', option_type: option_type)
      create(:option_value, name: '60 Capsules', presentation: '60 Capsules', option_type: option_type)
      create(:option_value, name: '120 Capsules', presentation: '120 Capsules', option_type: option_type)
    end
  end

  factory :five_servings, class: Spree::OptionValue do
    name '5 Servings'
    presentation '5 Servings'
  end


end
