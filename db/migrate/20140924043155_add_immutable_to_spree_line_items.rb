class AddImmutableToSpreeLineItems < ActiveRecord::Migration
  def change
    add_column :spree_line_items, :immutable, :boolean
  end
end
