class AddFullSkuToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :full_sku, :text
    add_index :shoppe_products, :full_sku
  end
end
