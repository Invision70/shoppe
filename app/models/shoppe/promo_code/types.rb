module Shoppe
  class PromoCode < ActiveRecord::Base

    self.inheritance_column = nil

    TYPE_CURRENCY = 'currency'
    TYPE_PERCENT = 'percent'

    # An array of all the types
    TYPES = [TYPE_CURRENCY, TYPE_PERCENT]

    # Validations
    validates :type, :inclusion => {:in => TYPES}

    after_initialize  { self.type = TYPES.first if self.type.blank? }

    def has_type?(type)
      self.type == type
    end

    def sign_type
      if self.has_type?(TYPE_CURRENCY)
        Shoppe.settings.currency_unit.html_safe
      elsif self.has_type?(TYPE_PERCENT)
        '%'
      end
    end

    def discount_text
      if self.has_type?(TYPE_CURRENCY)
        self.sign_type << self.discount.to_s
      elsif self.has_type?(TYPE_PERCENT)
        self.discount.to_s << self.sign_type
      end
    end

  end
end
