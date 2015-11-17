module Shoppe
  class PromoCode < ActiveRecord::Base
    validates :code, :discount, :presence => true
    # All active promo codes
    scope :active, -> { where(:active => true) }
  end
end
