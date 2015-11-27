class AddColumnsToAddresses < ActiveRecord::Migration
  def change
    add_column :shoppe_addresses, :first_name, :string
    add_column :shoppe_addresses, :last_name, :string
  end
end
