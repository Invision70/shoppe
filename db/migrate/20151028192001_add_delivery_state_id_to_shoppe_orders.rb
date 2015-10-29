class AddDeliveryStateIdToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :delivery_state_id, :integer
    add_index :shoppe_orders, :delivery_state_id
  end
end
