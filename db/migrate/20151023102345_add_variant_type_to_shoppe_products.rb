class AddVariantTypeToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :variant_type, :text
  end
end
