require 'spec_helper'

describe Spree::Promotion::Rules::UseConditionalAction do
  describe "A UseConditionalAction rule" do

    before do
      @rule = create(:use_conditional_action)
      @order = create(:order)
    end

    describe "#applicable" do
      it "should be applicable to an order" do
        assert @rule.applicable?(@order)
      end
    end

    describe "#eligible?" do
      before do
        @promotion = @rule.promotion
      end

      describe "when promotion has no actions" do
        it "should not be eligible" do
          assert !@rule.eligible?(@order)
        end
      end

      describe "when promotion has no conditional action" do
        it "should not be eligible" do
          @promotion.actions << build(:free_shipping)
          assert !@rule.eligible?(@order)
        end
      end

      describe "when promotion has a conditional action" do
        it "should be eligible" do
          @promotion.actions << build(:conditional_free_shipping)
          assert @rule.eligible?(@order)
        end
      end
    end
  end
end
