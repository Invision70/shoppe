class CreateShoppeStates < ActiveRecord::Migration
  def change
    create_table :shoppe_states do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
