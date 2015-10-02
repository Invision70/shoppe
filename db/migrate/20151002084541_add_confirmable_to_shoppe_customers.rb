class AddConfirmableToShoppeCustomers < ActiveRecord::Migration
  def up
    add_column :shoppe_customers, :confirmation_token, :string
    add_column :shoppe_customers, :confirmed_at, :datetime
    add_column :shoppe_customers, :confirmation_sent_at, :datetime
    # add_column :users, :unconfirmed_email, :string # if using reconfirmable
    add_index :shoppe_customers, :confirmation_token, unique: true
  end

  def down
    remove_columns :shoppe_customers, :confirmation_token, :confirmed_at, :confirmation_sent_at
    # remove_columns :users, :unconfirmed_email # if using reconfirmable
  end
end
