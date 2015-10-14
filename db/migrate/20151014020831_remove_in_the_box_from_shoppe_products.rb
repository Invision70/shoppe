class RemoveInTheBoxFromShoppeProducts < ActiveRecord::Migration
  def change
    remove_column :shoppe_products, :in_the_box, :text
  end
end
