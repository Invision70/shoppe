module Shoppe
  class OrderItem < ActiveRecord::Base
    after_save :refresh_promo_code
    after_destroy :refresh_promo_code

    private
      # Refresh promo code if condition changed
      def refresh_promo_code
        self.order.apply_promo_code(self.order.promo_code) if self.order.promo_code.present?
      rescue Shoppe::Errors::InvalidPromoCode
        self.order.clear_promo_code
      end
  end
end
