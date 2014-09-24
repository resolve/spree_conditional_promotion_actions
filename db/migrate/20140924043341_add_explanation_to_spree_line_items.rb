class AddExplanationToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :explanation, :string
  end
end
