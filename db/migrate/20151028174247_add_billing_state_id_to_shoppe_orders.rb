class AddBillingStateIdToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :billing_state_id, :integer
    add_index :shoppe_orders, :billing_state_id
  end
end
