class AddGiftProductIdToShoppePromoCodes < ActiveRecord::Migration
  def change
    add_column :shoppe_promo_codes, :gift_product_id, :integer
  end
end
