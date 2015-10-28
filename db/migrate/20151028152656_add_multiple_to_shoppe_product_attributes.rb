class AddMultipleToShoppeProductAttributes < ActiveRecord::Migration
  def change
    add_column :shoppe_product_attributes, :multiple, :boolean, :default => false
  end
end
