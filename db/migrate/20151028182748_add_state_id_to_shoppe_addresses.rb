class AddStateIdToShoppeAddresses < ActiveRecord::Migration
  def change
    add_column :shoppe_addresses, :state_id, :integer
    add_index :shoppe_addresses, :state_id
  end
end
