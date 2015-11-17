class AddPromoCodeToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :promo_code, :string
  end
end
