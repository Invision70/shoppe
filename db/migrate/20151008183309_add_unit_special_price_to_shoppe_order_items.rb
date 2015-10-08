class AddUnitSpecialPriceToShoppeOrderItems < ActiveRecord::Migration
  def change
    add_column :shoppe_order_items, :unit_special_price, :decimal, :precision => 8, :scale => 2
    add_index :shoppe_order_items, :unit_special_price
  end
end
