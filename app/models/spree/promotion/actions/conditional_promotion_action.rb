# Note that this class is not designed to be instantiated, just inherited from.
# It allows promotion actions to select between two different methods, depending
# on an eligibility check.
#
# A typical use case would be a promotion action that adds a free item to the
# cart if an order totals over a certain amount, and removes the free item if
# the customer changes the order so that it falls back below the threshold. This
# can't be done with standard Spree promotion rules, as they only fire actions
# when eligible.
#
# Subclasses should implement three public methods:
#   eligible?,
#   perform_eligible_action,
#   perform_ineligible_action
#
# Other methods would typically be private, and perform typically wouldn't need
# any override.

module Spree
  class Promotion
    module Actions
      class ConditionalPromotionAction < Spree::PromotionAction

        def eligible?(options = {})
          raise 'eligible?(options={}) should be implemented in a sub-class of ConditionalPromotionAction'
        end

        def perform(options = {})
          if self.eligible?(options)
            perform_eligible_action(options)
          else
            perform_ineligible_action(options)
          end
        end

        def perform_eligible_action(options={})
          raise 'perform_eligible_action(options={}) should be implemented in a sub-class of ConditionalPromotionAction'
        end

        def perform_ineligible_action(options={})
          raise 'perform_ineligible_action(options={}) should be implemented in a sub-class of ConditionalPromotionAction'
        end

      end
    end
  end
end
