module Shoppe
  class DeliveryServicePrice < ActiveRecord::Base

    # Set the table name
    self.table_name = 'shoppe_delivery_service_prices'

    include Shoppe::AssociatedCountries

    # The delivery service which this price belongs to
    belongs_to :delivery_service, :class_name => 'Shoppe::DeliveryService'

    # The tax rate which should be applied
    belongs_to :tax_rate, :class_name => "Shoppe::TaxRate"

    # Validations
    validates :code, :presence => true
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true
    validates :min_weight, :max_weight, :min_price, :max_price, :numericality => true, :allow_blank => true

    # All prices ordered by their price ascending
    scope :ordered, -> { order(:price => :asc) }

    # All prices which are suitable for the weight passed.
    #
    # @param weight [BigDecimal] the weight of the order
    scope :for_weight, -> weight { where("min_weight <= ? AND max_weight >= ?", weight, weight) }
    scope :for_price, -> price { where("min_price <= ? AND max_price >= ?", price, price) }
    scope :for_weight_or_price, -> weight, price { where("min_weight <= ? AND max_weight >= ? OR min_price <= ? AND max_price >= ?", weight, weight, price, price) }
  end
end
