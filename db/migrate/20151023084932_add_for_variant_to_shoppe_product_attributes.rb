class AddForVariantToShoppeProductAttributes < ActiveRecord::Migration
  def change
    add_column :shoppe_product_attributes, :for_variant, :boolean, :default => false
    add_index :shoppe_product_attributes, :for_variant
  end
end
