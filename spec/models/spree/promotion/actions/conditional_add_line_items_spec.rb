require 'spec_helper'

describe Spree::Promotion::Actions::ConditionalAddLineItems do
  describe "A ConditionalAddLineItems action" do

    before do
      # Assume a promotion where buying one of several shirt variants qualifies
      # qualifies you for two free mugs.

      shirt = create(:product, name: "Shirt")
      shirt.option_types << create(:supplement_size_option_type)
      @eligible_shirt_1 = create(:variant, product: shirt)
      @eligible_shirt_2 = create(:variant, product: shirt)
      @ineligible_shirt = create(:variant, product: shirt)

      mug = create(:product, name: "Mug")
      @free_promo_mug = create(:variant, product: mug)

      @action = create(:conditional_add_line_items)
      @action.preferred_match_policy = 'any'
      @action.promotion_action_match_line_items.create!(
        :variant => @eligible_shirt_1,
        :quantity => 1
      )
      @action.promotion_action_match_line_items.create!(
        :variant => @eligible_shirt_2,
        :quantity => 1
      )
      @action.promotion_action_line_items.create!(
        :variant => @free_promo_mug,
        :quantity => 2
      )

      @order = create(:order)

    end

    it "should not allow an immutable line item quantity to be changed" #move to line items test

    it "should handle multiple promotional items"
    it "should quietly fail if there's no stock of the promotional item"
    it "should handle any, all or none matches"

    describe "#eligible?" do
      it "should not be eligible when the order has no line items" do
        assert !@action.eligible?(order: @order)
      end
      it "should not be eligible when the order has only an ineligible line item" do
        @order.contents.add(@ineligible_shirt, 1)
        assert !@action.eligible?(order: @order)
      end
      it "should be eligible when the order has one of the required line items" do
        @order.contents.add(@eligible_shirt_1, 1)
        assert @action.eligible?(order: @order)
      end
      it "should be eligible when the order has multiple required line items" do
        @order.contents.add(@eligible_shirt_1, 1)
        @order.contents.add(@eligible_shirt_2, 1)
        assert @action.eligible?(order: @order)
      end
      it "should be eligible when the order has both eligible and ineligible line items" do
        @order.contents.add(@eligible_shirt_1, 1)
        @order.contents.add(@ineligible_shirt, 1)
        assert @action.eligible?(order: @order)
      end
    end

    describe "when the order is eligible" do
      before do
        @order.contents.add(@eligible_shirt_1, 21)
      end

      it "should have a promotional line item" do
        @action.perform({order: @order})
        assert_equal 2, @order.line_items.count
        free_mug_line_item = @order.line_items.find_by_variant_id(@free_promo_mug.id)
        assert free_mug_line_item
        assert_equal 2, free_mug_line_item.quantity
      end
      it "should have promotional line item as immutable" do
        @action.perform({order: @order})
        free_mug_line_item = @order.line_items.find_by_variant_id(@free_promo_mug.id)
        assert free_mug_line_item.immutable
      end

      it "should not add a duplicate promotional line item" do
        @action.perform({order: @order})
        @order.contents.add(@free_promo_mug, 1)
        @action.perform({order: @order})
        assert_equal 2, @order.line_items.count
        free_mug_line_item = @order.line_items.find_by_variant_id(@free_promo_mug.id)
        assert_equal 2, free_mug_line_item.quantity
      end

    end

    describe "when the order is not eligible" do
      before do
        @order.contents.add(@ineligible_shirt, 19)
      end
      it "should not add a promotional line item" do
        @action.perform({order: @order})
        assert_equal 1, @order.line_items.count
        assert !@order.line_items.find_by_variant_id(@free_promo_mug.id)
      end
    end

    it "should work if promotional line item is also a customer line item i.e. buy-one-get-one-free"

  end
end
