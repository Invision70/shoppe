class AddPhoneToAddresses < ActiveRecord::Migration
  def change
    add_column :shoppe_addresses, :phone_number, :string
  end
end
