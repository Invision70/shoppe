module Shoppe
  class PromoCode < ActiveRecord::Base

    # Require dependencies
    require_dependency 'shoppe/promo_code/types'

    validates :code, :discount, :presence => true
    # All active promo codes
    scope :active, -> { where(:active => true) }
  end
end
