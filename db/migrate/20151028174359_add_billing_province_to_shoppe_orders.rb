class AddBillingProvinceToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :billing_province, :text
  end
end
