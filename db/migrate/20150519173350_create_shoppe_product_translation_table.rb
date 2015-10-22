class CreateShoppeProductTranslationTable < ActiveRecord::Migration
  def up
    Shoppe::Product.create_translation_table! :name => :string, :permalink => :string, :description => :text

    Shoppe::Product.all.each do |p|
      l = p.translations.new
      l.locale = "en"
      l.name = p.name
      l.permalink = p.permalink
      l.description = p.description
      l.save!
    end
  end
  def down
    Shoppe::Product.drop_translation_table!
  end
end
