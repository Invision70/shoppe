require 'awesome_nested_set'

module Shoppe
  class Product < ActiveRecord::Base

    acts_as_nested_set parent_column: :variant_parent_id

    belongs_to :variant_parent, :class_name => self.base_class.to_s,
               :foreign_key => parent_column_name,
               :primary_key => primary_column_name,
               :counter_cache => acts_as_nested_set_options[:counter_cache],
               :inverse_of => (:children unless acts_as_nested_set_options[:polymorphic]),
               :polymorphic => acts_as_nested_set_options[:polymorphic],
               :touch => acts_as_nested_set_options[:touch]

    # Validations
    validate { errors.add :base, :can_belong_to_root if self.parent && self.parent.parent }

    # Variants of the product
    has_many :variants, :class_name => 'Shoppe::Product', :foreign_key => 'parent_id', :dependent => :destroy

    # The parent product (only applies to variants)
    belongs_to :parent, :class_name => 'Shoppe::Product', :foreign_key => 'parent_id'

    # All products which are not variants
    scope :not_variants, -> { where(:parent_id => nil) }

    # No descendents
    scope :except_descendants, ->(record) { where.not(id: (Array.new(record.descendants) << record).flatten) if record }

    # If a variant is created, the base product should be updated so that it doesn't have stock control enabled
    after_create do

      if self.variant? && ! self.root_variant?
        self.variant_parent.price = 0
        self.variant_parent.cost_price = 0
        self.variant_parent.special_price = 0
        self.variant_parent.tax_rate = nil
        self.variant_parent.weight = 0
        self.variant_parent.stock_control = false
        self.variant_parent.default = false
        self.variant_parent.save if self.variant_parent.changed?
      end

    end

    before_save do

      if self.has_variants? && self.valid?

        if self.changed_attributes[:price]
          self.variants.update_all(:price => read_attribute(:price))
        end

        if self.changed_attributes[:special_price]
          self.variants.update_all(:special_price => read_attribute(:special_price))
        end

        if self.changed_attributes[:cost_price]
          self.variants.update_all(:cost_price => read_attribute(:cost_price))
        end

      end
    end

    before_save do
      self.full_sku = self.full_sku_tree
    end

    # Does this product have any variants?
    #
    # @return [Boolean]
    def has_variants?
      !variants.empty?
    end

    # SKU with tree nodes
    def full_sku_tree
      String.new.tap do |s|
        if self.variant?
          s << self.parent.sku
          s << '-'
          if self.root_variant?
            s << self.sku
          else
            s << self.variant_parent.sku
            s << '-'
            s << self.sku
          end
        else
          s << self.sku
        end
      end
    end

    # Returns the default variant for the product or nil if none exists.
    #
    # @return [Shoppe::Product]
    def default_variant
      return nil if self.parent
      @default_variant ||= self.variants.select { |v| v.default? }.first
    end

    # Return the name of the product
    #
    # @return [String]
    def full_name
      String.new.tap do |s|
        if self.variant?
          s << self.parent.name
          s << ' ('
          if root_variant?
            s << name
          else
            s << self.variant_parent.variant_type
            s << ': '
            s << self.variant_parent.name
            s << ', '
            s << self.variant_type
            s << ': '
            s << name
          end
          s << ')'
        else
          s << name
        end
      end
    end

    # Is this product a variant of another?
    #
    # @return [Boolean]
    def variant?
      self.parent.present?
    end

    def child_variants_exists?
      self.variants.where(:depth => 1).count > 0
    end

    # Return true if root variant in stock
    #
    # @return [Boolean]
    def child_variants_in_stock?
      (self.child_variants_stock || 0) > 0 || self.child_variants_stock_control_disabled?
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    # @return [nil]
    def child_variants_stock
      if self.root_variant?
        self.descendants.where(:stock_control => true).inject(0) { |sum, a| sum + a.stock_level_adjustments.sum(:adjustment) }
      end
    end

    # Return true if root variant stock control
    #
    # @return [Boolean]
    def child_variants_stock_control_disabled?
      if self.root_variant?
        self.descendants.where(:stock_control => false).length > 0
      else
        false
      end
    end

    # Return true if parent variant in stock
    #
    # @return [Boolean]
    def child_variants_stock_control?
      if self.root_variant?
        self.descendants.where(:stock_control => true).length > 0
      else
        false
      end
    end

    # Return true if variant is parent
    #
    # @return [Boolean]
    def root_variant?
      self.variant? && self.root?
    end


    # Is this product currently in stock?
    #
    # @return [Boolean]
    def in_stock?
      if self.child_variants_exists?
        self.variants.roots.inject(false) { |any, i| any ||= i.child_variants_in_stock? }
      elsif self.has_variants?
        self.variants.inject(false) { |any, i| any ||= i.stock_control? ? i.stock > 0 : true }
      else
        stock_control? ? stock > 0 : true
      end
    end

    # Return the total number of items currently in stock
    #
    # @return [Fixnum]
    def stock
      if self.has_variants?
        self.variants.roots.inject(0) { |sum, i| sum + (i.leaf? ? i.stock_level_adjustments.sum(:adjustment) : i.child_variants_stock) }
      else
        self.stock_level_adjustments.sum(:adjustment)
      end
    end

  end
end
