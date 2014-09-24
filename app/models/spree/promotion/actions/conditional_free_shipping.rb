module Spree
  class Promotion
    module Actions
      class ConditionalFreeShipping < Spree::Promotion::Actions::ConditionalPromotionAction
        has_many :adjustments, as: :source

        # before_destroy :deals_with_adjustments

        preference :quantity, :integer, default: 100
        preference :product_id, :integer

        # TODO: move shared eligible? to abstract class for actions conditional on order quantity
        # TODO: delegate successful action to standard Spree free_shipping action

        # TODO: is this triggered on order update?

        def eligible?(options = {})
          return unless order = options[:order]
          quantity_ordered = product.variants_including_master.inject(0) do |sum, v|
            sum + order.quantity_of(v)
          end
          quantity_ordered >= preferred_quantity
        end

        def perform_eligible_action(payload={})
          return unless order = payload[:order]
          results = order.shipments.map do |shipment|
            return false if promotion_credit_exists?(shipment)
            self.create_adjustment(shipment)
            true
          end
          # Did we actually end up applying any adjustments?
          # If so, then this action should be classed as 'successful'
          results.any? { |r| r == true }

        end

        def perform_ineligible_action(payload={})
          return unless order = payload[:order]
          results = order.shipments.map do |shipment|
            self.remove_adjustment(shipment)
          end
        end

        def label
          "#{Spree.t(:promotion)} (#{promotion.name})"
        end

        def compute_amount(shipment)
          shipment.cost * -1
        end

        def create_adjustment(shipment)
          shipment.adjustments.create!(
            order: shipment.order,
            amount: compute_amount(shipment),
            source: self,
            label: label,
          )
        end

        def remove_adjustment(adjustable)
          adjustable.adjustments.where(source_id: self.id).destroy_all
        end

        private

          def promotion_credit_exists?(shipment)
            shipment.adjustments.where(:source_id => self.id).exists?
          end

          def product
            ::Spree::Product.find(preferred_product_id)
          end


      end
    end
  end
end
