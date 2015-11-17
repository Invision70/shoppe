class AddPermalinkToShoppePages < ActiveRecord::Migration
  def change
    add_column :shoppe_pages, :permalink, :string
    add_index :shoppe_pages, :permalink
  end
end
