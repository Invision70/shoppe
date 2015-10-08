class AddSpecialPriceToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :special_price, :decimal, :precision => 8, :scale => 2, default: 0.0
    add_index :shoppe_products, :special_price
  end
end
