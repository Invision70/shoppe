class RemoveShortDescriptionFromShoppeProductTranslations < ActiveRecord::Migration
  def change
    if column_exists? :shoppe_product_translations, :short_description
      remove_column :shoppe_product_translations, :short_description, :text
    end
  end
end
