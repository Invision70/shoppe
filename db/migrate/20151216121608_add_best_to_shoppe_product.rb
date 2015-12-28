class AddBestToShoppeProduct < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :best, :integer, default: 0
  end
end
