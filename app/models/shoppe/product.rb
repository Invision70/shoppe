require "roo"
require "globalize"

module Shoppe
  class Product < ActiveRecord::Base

    include ActionView::Helpers::SanitizeHelper

    after_create :link_attachments

    self.table_name = 'shoppe_products'

    define_model_callbacks :stock_level_changed, :only => [:before, :after]

    # Add dependencies for products
    require_dependency 'shoppe/product/product_attributes'
    require_dependency 'shoppe/product/variants'

    # Attachments for this product
    has_many :attachments, -> { order(sort: :asc, id: :asc) }, :as => :parent, :dependent => :destroy, :autosave => true, :class_name => "Shoppe::Attachment"

    # The product's categorizations
    #
    # @return [Shoppe::ProductCategorization]
    has_many :product_categorizations, dependent: :destroy, class_name: 'Shoppe::ProductCategorization', inverse_of: :product
    # The product's categories
    #
    # @return [Shoppe::ProductCategory]
    has_many :product_categories, class_name: 'Shoppe::ProductCategory', through: :product_categorizations

    # The product's tax rate
    #
    # @return [Shoppe::TaxRate]
    belongs_to :tax_rate, :class_name => "Shoppe::TaxRate"

    # Ordered items which are associated with this product
    has_many :order_items, :dependent => :restrict_with_exception, :class_name => 'Shoppe::OrderItem', :as => :ordered_item

    # Orders which have ordered this product
    has_many :orders, :through => :order_items, :class_name => 'Shoppe::Order'

    # Stock level adjustments for this product
    has_many :stock_level_adjustments, :dependent => :destroy, :class_name => 'Shoppe::StockLevelAdjustment', :as => :item

    # Validations
    with_options :if => Proc.new { |p| p.parent.nil? } do |product|
      product.validate :has_at_least_one_product_category
    end
    validates :name, :presence => true
    validates :permalink, :presence => true, :permalink => true
    validates :permalink, :uniqueness => true, :unless => :parent_id?
    validates :sku, :presence => true
    validates :weight, :numericality => true
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true
    validates :special_price, :numericality => true, :allow_blank => true

    # Before validation, set the permalink if we don't already have one
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }

    # All active products
    scope :active, -> { where(:active => true) }

    # All stock availability products
    scope :stock_availability, -> { where(:stock_availability => true) }

    # All featured products
    scope :featured, -> {where(:featured => true)}

    # Localisations
    translates :name, :permalink, :description
    scope :ordered, -> { includes(:translations).order(:name) }

    def attachments=(attrs)
      if attrs["default_image"].present? && attrs["default_image"]["file"].present? then self.attachments.build(attrs["default_image"]) end
      if attrs["extra"]["file"].present? then attrs["extra"]["file"].each { |attr| self.attachments.build(file: attr, parent_id: attrs["extra"]["parent_id"], parent_type: attrs["extra"]["parent_type"]) } end
    end

    # Is this product orderable?
    #
    # @return [Boolean]
    def orderable?
      return false unless self.active?
      return false if self.has_variants?
      true
    end

    # The price for the product
    #
    # @return [BigDecimal]
    def price
      # self.default_variant ? self.default_variant.price : read_attribute(:price)
      self.default_variant ? self.default_variant.price : read_attribute(:price)
    end

    # The special price for the product
    #
    # @return [BigDecimal]
    def special_price
      # self.default_variant ? self.default_variant.special_price : read_attribute(:special_price)
      self.default_variant ? self.default_variant.special_price : read_attribute(:special_price)
    end

    # Is special price?
    #
    # @return [Boolean]
    def special_price?
      self.special_price.present? && self.special_price > 0 && self.special_price < self.price
    end

    # The selling price for the product
    #
    # @return [BigDecimal]
    def selling_price
      self.special_price? ? self.special_price : self.price
    end

    # Return the first product category
    #
    # @return [Shoppe::ProductCategory]
    def product_category
      self.product_categories.first rescue nil
    end

    def description
      sanitize read_attribute(:description), tags: %w(strong em a b u i ul li dl dd dt p br font div), attributes: %w(href target color)
    end

    # Return attachment for the default_image role
    #
    # @return [String]
    def default_image
      default_image = self.attachments.first
      if self.parent_id? && default_image.blank?
        self.parent.attachments.first
      else
        default_image
      end
    end

    def selection_size
      sizes = %w("XS S M L XL XXL 2X XXXL 3X XXXXL 4X")
      self.variants
          .stock_availability
          .map { |e| {:key => e.variant_type, :value => e.name, :id => e.id} }
          .uniq
          .sort_by {|e| e[:value].to_s == e[:value].to_i.to_s ? e[:value] : sizes.index(e[:value]) || 0 } # check if integer or sort by index
    end

    def link_attachments
      Shoppe::Attachment.where(parent_id: nil).update_all(parent_id: self.id)
    end

    # Set attachment for the default_image role
    def default_image_file=(file)
      self.attachments.build(:file => file, :sort => '-1', :role => 'default_image')
    end

    # Search for products which include the given attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    #
    # @return [Enumerable]
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(:key => key, :value => values).pluck(:product_id).uniq
      where(:id => product_ids)
    end

    # Imports products from a spreadsheet file
    # Example:
    #
    #   Shoppe:Product.import("path/to/file.csv")
    def self.import(file)
      spreadsheet = open_spreadsheet(file)
      spreadsheet.default_sheet = spreadsheet.sheets.first
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]

        # Don't import products where the name is blank
        unless row["name"].nil?
          if product = where(name: row["name"]).take
            # Dont import products with the same name but update quantities
            qty = row["qty"].to_i
            if qty > 0
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          else
            product = new
            product.name = row["name"]
            product.sku = row["sku"]
            product.description = row["description"]
            product.weight = row["weight"]
            product.price = row["price"].nil? ? 0 : row["price"]
            product.permalink  = row["permalink"]

            product.product_categories << begin
              if Shoppe::ProductCategory.where(name: row["category_name"]).present?
                Shoppe::ProductCategory.where(name: row["category_name"]).take
              else
                Shoppe::ProductCategory.create(name: row["category_name"])
              end
            end

            product.save!

            qty = row["qty"].to_i
            if qty > 0
              product.stock_level_adjustments.create!(description: I18n.t('shoppe.import'), adjustment: qty)
            end
          end
        end
      end
    end

    def self.open_spreadsheet(file)
      case File.extname(file.original_filename)
      when ".csv" then Roo::CSV.new(file.path)
      when ".xls" then Roo::Excel.new(file.path)
      when ".xlsx" then Roo::Excelx.new(file.path)
      else raise I18n.t('shoppe.imports.errors.unknown_format', filename: File.original_filename)
      end
    end

    private

    # Validates

    def has_at_least_one_product_category
      errors.add(:base, 'must add at least one product category') if self.product_categories.blank?
    end

  end
end
