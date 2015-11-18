class AddPriceToShoppeDeliveryServicePrices < ActiveRecord::Migration
  def change
    add_column :shoppe_delivery_service_prices, :min_price, :decimal
    add_column :shoppe_delivery_service_prices, :max_price, :decimal
  end
end
