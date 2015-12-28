module Shoppe
  class Order < ActiveRecord::Base
    after_apply_promo_code do
      # Add gift product
      self.destroy_gift_products
      gift_product = self.promo.try(:gift_product)
      if gift_product.present? && gift_product.in_stock?
        self.order_items.create(:ordered_item => gift_product, :quantity => 1, :unit_price => 0, :unit_special_price => 0,
                                :tax_amount => 0, :tax_rate => 0, :gift => true)
      end

      begin

      rescue
        # @TODO Notify if gift product is invalid
      end
    end

    before_clear_promo_code do
      self.destroy_gift_products
    end

    def destroy_gift_products
      self.order_items.where(:gift => true).destroy_all
    end

  end
end