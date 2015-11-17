class CreateShoppePages < ActiveRecord::Migration
  def change
    create_table :shoppe_pages do |t|
      t.string :title
      t.string :menu_title
      t.text :content
      t.boolean :published, default: true
      t.boolean :show_menu, default: true
      t.integer :priority, default: 0

      t.timestamps
    end
  end
end
