module Shoppe
  class Order < ActiveRecord::Base

    def apply_promo_code(code)
      self.discount = nil
      promo_codes = Shoppe::PromoCode.active.where('code ILIKE ?', code).where(['end_at IS NULL OR end_at >= ?', DateTime.now]).order('min_price DESC').all
      promo_codes.each do |promo_code|
        if (promo_code.min_price.nil? || self.items_sub_total >= promo_code.min_price) && (promo_code.max_price.nil? || self.items_sub_total <= promo_code.max_price)
          if promo_code.has_type?(Shoppe::PromoCode::TYPE_PERCENT)
            disount_value = self.items_sub_total*0.01*promo_code.discount
          else
            disount_value = promo_code.discount
          end
          self.update_attributes(discount: disount_value, promo_code_type: promo_code.type, promo_code: promo_code.code) # Apply order discount
          break
        end
      end
      unless self.discount?
        self.discount = read_attribute(:discount)
        raise Shoppe::Errors::InvalidPromoCode, :order => self
      end
      true
    end

    def clear_promo_code
      self.update_attributes(discount: nil, promo_code: nil)
    end

    def total
      self.delivery_price +
      self.delivery_tax_amount +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total } -
      (self.discount || BigDecimal(0))
    end

  end
end
