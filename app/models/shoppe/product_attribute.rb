module Shoppe
  class ProductAttribute < ActiveRecord::Base

    self.table_name = 'shoppe_product_attributes'

    # Validations
    validates :key, :presence => true

    # The associated product
    #
    # @return [Shoppe::Product]
    belongs_to :product, :class_name => 'Shoppe::Product'

    # All attributes which are searchable
    scope :searchable, -> { where(:searchable => true) }

    # All attributes which are public
    scope :publicly_accessible, -> { where(:public => true) }

    scope :ordered, -> { order(:position => :desc) }

    # Return the available options as a hash
    #
    # @return [Hash]
    def self.grouped_hash
      ordered.group_by(&:key).inject(Hash.new) do |h, (key, attributes)|
        h[key] = attributes.map(&:value).uniq
        h
      end
    end

    # Create/update attributes for a product based on the provided hash of
    # keys & values.
    #
    # @param array [Array]
    def self.update_from_array(array)
      existing_keys = self.pluck(:key)

      self.delete_all

      array.each do |hash|
        next if hash['key'].blank? || hash['value'].blank?
        
        params = hash.merge({
          :searchable => hash[:searchable].to_s == '1',
          :public => hash[:public].to_s == '1',
          :multiple => hash[:multiple].to_s == '1',
          :position => hash[:position]
        })
        self.create(params)
      end
      true
    end

    def self.public
      ActiveSupport::Deprecation.warn("The use of Shoppe::ProductAttribute.public is deprecated. use Shoppe::ProductAttribute.publicly_accessible.")
      self.publicly_accessible
    end

    def self.ransackable_attributes(auth_object = nil)
      ["key", "value"] + _ransackers.keys
    end

    def self.ransackable_associations(auth_object = nil)
      []
    end

  end
end
