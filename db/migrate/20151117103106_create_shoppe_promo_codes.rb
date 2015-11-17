class CreateShoppePromoCodes < ActiveRecord::Migration
  def change
    create_table :shoppe_promo_codes do |t|
      t.string :code
      t.text :description
      t.decimal :discount, :precision => 8, :scale => 2, default: 0.0
      t.decimal :min_price, :precision => 8, :scale => 2
      t.decimal :max_price, :precision => 8, :scale => 2
      t.boolean :active, default: true
      t.datetime :end_at

      t.timestamps
    end
    add_index :shoppe_promo_codes, :active
    add_index :shoppe_promo_codes, :code
  end
end
