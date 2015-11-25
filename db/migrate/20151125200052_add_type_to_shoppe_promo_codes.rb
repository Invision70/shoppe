class AddTypeToShoppePromoCodes < ActiveRecord::Migration
  def change
    add_column :shoppe_promo_codes, :type, :string, default: 'currency'
  end
end
