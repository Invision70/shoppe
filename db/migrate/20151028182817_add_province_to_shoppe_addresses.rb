class AddProvinceToShoppeAddresses < ActiveRecord::Migration
  def change
    add_column :shoppe_addresses, :province, :text, :default => ''
  end
end
