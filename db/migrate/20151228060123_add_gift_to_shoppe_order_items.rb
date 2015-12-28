class AddGiftToShoppeOrderItems < ActiveRecord::Migration
  def change
    add_column :shoppe_order_items, :gift, :boolean, :default => false
    add_index :shoppe_order_items, :gift
  end
end
