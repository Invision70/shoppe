class AddStockAvailabilityToShoppeProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :stock_availability, :boolean, :default => true
  end
end
