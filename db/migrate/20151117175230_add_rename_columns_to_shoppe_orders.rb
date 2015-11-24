class AddRenameColumnsToShoppeOrders < ActiveRecord::Migration
  def change
    rename_column :shoppe_orders, :first_name, :billing_first_name
    rename_column :shoppe_orders, :last_name, :billing_last_name
    rename_column :shoppe_orders, :phone_number, :billing_phone_number
    add_column :shoppe_orders, :delivery_first_name, :string
    add_column :shoppe_orders, :delivery_last_name, :string
    add_column :shoppe_orders, :delivery_phone_number, :string
  end
end
