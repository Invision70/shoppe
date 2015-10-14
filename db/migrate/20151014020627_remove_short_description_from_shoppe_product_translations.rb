class RemoveShortDescriptionFromShoppeProductTranslations < ActiveRecord::Migration
  def change
    remove_column :shoppe_product_translations, :short_description, :text
  end
end
