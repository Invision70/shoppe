module Shoppe
  class OrderItem < ActiveRecord::Base

    after_commit :refresh_promo_code, on: [:create, :update, :destroy]

    private
      # Refresh promo code if condition changed
      def refresh_promo_code
        self.order.apply_promo_code(self.order.promo_code) if self.order.promo_code.present?
      rescue Shoppe::Errors::InvalidPromoCode
        self.order.clear_promo_code
      end
  end
end
