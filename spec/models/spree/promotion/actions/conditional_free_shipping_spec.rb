require 'spec_helper'

describe Spree::Promotion::Actions::ConditionalFreeShipping do
  describe "A ConditionalFreeShipping action" do

    before do
      # Assume a promotion where customers get a free mug when their order has at least twenty shirts
      @shirt = create(:variant, price: 100)
      @mug = create(:variant)

      @action = create(:conditional_free_shipping)
      @action.preferred_product_id = @shirt.product.id
      @action.preferred_quantity = 20

      @order = create(:order)
    end

    describe "#eligible?" do
      it "should be eligible when the quantity is more than required" do
        @order.contents.add(@shirt, 21)
        assert @action.eligible?(order: @order)
      end
      it "should be eligible when the quantity is exactly the required" do
        @order.contents.add(@shirt, 20)
        assert @action.eligible?(order: @order)
      end
      it "should be not be eligible when the quantity is too low" do
        @order.contents.add(@shirt, 19)
        assert !@action.eligible?(order: @order)
      end
    end

    describe "when the order is eligible" do
      before do
        @order.contents.add(@shirt, 20)
        @order.shipments << create(:shipment)
      end

      it "should apply free shipping" do
        @action.perform(order: @order)
        assert_equal 1, @order.shipment_adjustments.count
        assert_equal -100, @order.shipment_adjustments.to_a.sum(&:amount)
      end
      it "should not apply free shipping a second time" do
        @order.contents.add(@shirt, 10)
        @action.perform(order: @order)
        assert_equal 1, @order.shipment_adjustments.count
        assert_equal -100, @order.shipment_adjustments.to_a.sum(&:amount)
      end
      it "should remove free shipping when order subsequently becomes ineligible" do
        @order.contents.remove(@shirt, 10)
        @action.perform(order: @order)
        assert_equal 0, @order.shipment_adjustments.count
        assert_equal 0, @order.shipment_adjustments.to_a.sum(&:amount)
      end
    end

    describe "when the order is ineligible" do
      before do
        @order.contents.add(@shirt, 19)
        @order.shipments << create(:shipment)

        # Spree::OrderUpdater.new(@order).update_shipment_total
      end
      it "should not apply free shipping" do
        @action.perform(order: @order)
        assert_equal 0, @order.shipment_adjustments.count
        assert_equal 0, @order.shipment_adjustments.to_a.sum(&:amount)
      end
    end

  end
end
