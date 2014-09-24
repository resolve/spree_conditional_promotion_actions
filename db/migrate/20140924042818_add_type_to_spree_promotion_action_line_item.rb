class AddTypeToSpreePromotionActionLineItem < ActiveRecord::Migration
  def change
    add_column :spree_promotion_action_line_items, :type, :string
  end
end
