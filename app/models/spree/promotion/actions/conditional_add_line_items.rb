module Spree
  class Promotion
    module Actions
      class ConditionalAddLineItems < Spree::Promotion::Actions::ConditionalPromotionAction

        MATCH_POLICIES = %w(any all none)
        preference :match_policy, :string, default: MATCH_POLICIES.first
        preference :explanation, :string, default: "Promotional item"

        has_many :promotion_action_line_items, -> { where type: nil }, foreign_key: :promotion_action_id
        accepts_nested_attributes_for :promotion_action_line_items, allow_destroy: true

        has_many :promotion_action_match_line_items, foreign_key: :promotion_action_id
        accepts_nested_attributes_for :promotion_action_match_line_items, allow_destroy: true

        # Hat tip: Brian Buchalter http://blog.endpoint.com/2013/08/buy-one-get-one-promotion-with-spree.html

        def eligible?(options = {})
          return unless order = options[:order]

          if preferred_match_policy == 'all'
            eligible_variants.all? {|p| order.products.include?(p) }
          elsif preferred_match_policy == 'any'
            order.line_items.any? {|li| matches_a_promo_line_item?(li)}
          else
            order.products.none? {|p| eligible_variants.include?(p) }
          end
        end

        def perform_eligible_action(options={})
          return unless order = options[:order]

          promotion_action_line_items.each do |promotion_action_line_item|
            existing_line_item = find_existing_line_item(promotion_action_line_item, order)
            if existing_line_item
              existing_line_item.update_attribute(:quantity, promotion_action_line_item.quantity)
            else
              create_line_item(promotion_action_line_item, order)
            end
          end
        end

        def perform_ineligible_action(options={})
          return unless order = options[:order]
          remove_promotional_line_items(order)
        end

        private
          def matches_a_promo_line_item?(order_line_item)
            promotion_action_match_line_items.any? { |promotion_action_match_line_item|
              order_line_item.variant == promotion_action_match_line_item.variant &&
              order_line_item.quantity >= promotion_action_match_line_item.quantity
            }
          end

          def eligible_variants
            promotion_action_match_line_items
          end

          def create_line_item(promotion_action_line_item, order)
            variant = promotion_action_line_item.variant
            quantity = promotion_action_line_item.quantity

            current_quantity = order.quantity_of(variant)
            if current_quantity < quantity
              quantity_to_add = quantity - current_quantity
              new_line_item = order.line_items.new( quantity: quantity_to_add,
                                    variant: variant,
                                    immutable: true,
                                    explanation: preferred_explanation,
                                    price: variant.price
                                  )
              new_line_item.save
            end
          end

          def remove_promotional_line_items(order)
            order.line_items.each do |li|
              li.destroy if is_a_promotional_line_item?(li)
            end
          end

          def find_existing_line_item(line_item, order)
            order.line_items.find_by(variant_id: line_item.variant_id)
          end

          def is_a_promotional_line_item?(line_item)
            line_item.variant == promotion_action_line_items.first.variant
          end

          def product
            ::Spree::Product.find(preferred_product_id)
          end

      end
    end
  end
end
