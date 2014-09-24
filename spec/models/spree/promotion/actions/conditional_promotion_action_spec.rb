require 'spec_helper'

describe Spree::Promotion::Actions::ConditionalPromotionAction do
  describe "A ConditionalPromotionAction action" do

    before do
      @action = create(:conditional_promotion_action)
    end

    it "should Raise an error when #eligible? is called" do
      exception = assert_raises(RuntimeError) { @action.eligible? }
      assert_equal( "eligible?(options={}) should be implemented in a sub-class of ConditionalPromotionAction", exception.message )
    end

    it "should Raise an error when #perform_eligible_action is called" do
      exception = assert_raises(RuntimeError) { @action.perform_eligible_action }
      assert_equal( "perform_eligible_action(options={}) should be implemented in a sub-class of ConditionalPromotionAction", exception.message )
    end

    it "should Raise an error when #perform_ineligible_action is called" do
      exception = assert_raises(RuntimeError) { @action.perform_ineligible_action }
      assert_equal( "perform_ineligible_action(options={}) should be implemented in a sub-class of ConditionalPromotionAction", exception.message )
    end

  end
end
