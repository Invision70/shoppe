class AddDiscountToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :discount, :decimal, :precision => 8, :scale => 2
  end
end
