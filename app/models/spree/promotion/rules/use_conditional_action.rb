# A rule to limit a promotion based on products in the order.
# Can require all or any of the products to be present.
# Valid products either come from assigned product group or are assingned directly to the rule.
module Spree
  class Promotion
    module Rules
      class UseConditionalAction < PromotionRule

        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          promotion.actions.any?{|a| a.is_a?(Spree::Promotion::Actions::ConditionalPromotionAction)}
        end

      end
    end
  end
end
