class AddPromoCodeTypeToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :promo_code_type, :string
  end
end
