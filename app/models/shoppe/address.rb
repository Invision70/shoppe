module Shoppe
  class Address < ActiveRecord::Base

    # An array of all the available types for an address
    TYPES = ["billing", "delivery"]

    # Set the table name
    self.table_name = "shoppe_addresses"

    # The customer which this address should be linked to
    #
    # @return [Shoppe::Customer]
    belongs_to :customer, :class_name => "Shoppe::Customer"

    # The order which this address should be linked to
    #
    # @return [Shoppe::Order]
    belongs_to :order, :class_name => "Shoppe::Order"

    # The country which this address should be linked to
    #
    # @return [Shoppe::Country]
    belongs_to :country, :class_name => "Shoppe::Country"

    # The state which this address should be linked to
    #
    # @return [Shoppe::State]
    belongs_to :state, :class_name => "Shoppe::State"

    # Validations
    validates :address_type, :presence => true, :inclusion => {:in => TYPES}
    validates :address1, :postcode, :country, :state, :first_name, :last_name, :phone_number, :address3, :presence => true
    validates :first_name, :last_name, :address1, :address2, :address3, :province, :latin => true, :if => Proc.new{ Shoppe.settings.only_latin_address? }

    # All addresses ordered by their id asending
    scope :ordered, -> { order(:id => :desc)}
    scope :default, -> { where(default: true)}
    scope :billing, -> { where(address_type: "billing")}
    scope :delivery, -> { where(address_type: "delivery")}

    def full_address
      [first_name, last_name, phone_number, address1, address2, address3, address4, postcode, country.try(:name), state.try(:name), province].reject(&:blank?).join(", ")
    end

  end
end
