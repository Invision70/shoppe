class AddNewsletterSubscribedToShoppeCustomers < ActiveRecord::Migration
  def change
    add_column :shoppe_customers, :newsletter_subscribed, :boolean, :default => true
    add_index :shoppe_customers, :newsletter_subscribed
  end
end
