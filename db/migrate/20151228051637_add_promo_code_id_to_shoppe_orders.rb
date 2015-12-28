class AddPromoCodeIdToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :promo_code_id, :integer
  end
end
