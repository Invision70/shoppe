module Shoppe
  class PromoCode < ActiveRecord::Base

    # Require dependencies
    require_dependency 'shoppe/promo_code/types'

    belongs_to :gift_product, :class_name => 'Shoppe::Product', foreign_key: 'gift_product_id'

    validates :code, :discount, :presence => true
    # All active promo codes
    scope :active, -> { where(:active => true) }
  end
end
