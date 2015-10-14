class RemoveShortDescriptionFromShoppeProducts < ActiveRecord::Migration
  def change
    remove_column :shoppe_products, :short_description, :text
  end
end
