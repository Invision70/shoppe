module Shoppe
  class OrderItem < ActiveRecord::Base

    after_commit :refresh_promo_code, on: [:create, :update, :destroy]

    private
      # Refresh promo code if condition changed
      def refresh_promo_code
        unless self.order.destroyed?
          order_item = self.order.reload
          order_item.apply_promo_code(order_item.promo_code) if order_item.promo_code.present?
        end
      rescue Shoppe::Errors::InvalidPromoCode
        order_item.clear_promo_code unless order_item.destroyed?
      end
  end
end
