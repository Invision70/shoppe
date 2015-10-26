class AddNestedToShoppeProducts < ActiveRecord::Migration
  def self.up
    add_column :shoppe_products, :variant_parent_id, :integer # Comment this line if your project already has this column
    # Category.where(parent_id: 0).update_all(parent_id: nil) # Uncomment this line if your project already has :parent_id
    add_column :shoppe_products, :lft,       :integer
    add_column :shoppe_products, :rgt,       :integer

    # optional fields
    add_column :shoppe_products, :depth,          :integer
    add_column :shoppe_products, :children_count, :integer

  end

  def self.down
    remove_column :shoppe_products, :variant_parent_id
    remove_column :shoppe_products, :lft
    remove_column :shoppe_products, :rgt

    # optional fields
    remove_column :shoppe_products, :depth
    remove_column :shoppe_products, :children_count
  end
end
