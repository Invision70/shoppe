class AddDeliveryProvinceToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :delivery_province, :text
  end
end
