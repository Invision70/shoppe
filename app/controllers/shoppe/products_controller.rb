module Shoppe
  class ProductsController < Shoppe::ApplicationController

    helper_method :product_attributes

    before_filter {
      @active_nav = :products
      @attributes = Shoppe::ProductAttribute.where(for_variant: false).grouped_hash
    }

    before_filter { @product = Shoppe::Product.root.find(params[:id]) if params[:id] }
    before_filter { params[:product][:product_category_ids].map! { |category_id| category_id if Shoppe::ProductCategory.find(category_id).leaf? } if params[:product] && params[:product][:product_category_ids] }

    def index
      @products = initialize_grid Shoppe::Product.root.includes(:translations, :stock_level_adjustments, :product_categories, :variants), order: 'id', order_direction: 'desc'
    end

    def new
      @product = Shoppe::Product.new
    end

    def create
      @product = Shoppe::Product.new(safe_params)
      if @product.save
        redirect_to :products, :flash => {:notice => t('shoppe.products.create_notice') }
      else
        render :action => "new"
      end
    end

    def edit

    end

    def update
      if @product.update(safe_params)
        redirect_to [:edit, @product], :flash => {:notice => t('shoppe.products.update_notice') }
      else
        render :action => "edit"
      end
    end

    def destroy
      @product.destroy
      redirect_to :products, :flash => {:notice =>  t('shoppe.products.destroy_notice')}
    end

    def import
      if request.post?
        if params[:import].nil?
          redirect_to import_products_path, :flash => {:alert => I18n.t('shoppe.imports.errors.no_file')}
        else
          Shoppe::Product.import(params[:import][:import_file])
          redirect_to products_path, :flash => {:notice => I18n.t("shoppe.products.imports.success")}
        end
      end
    end

    private

    def product_attributes(product)
      if product.new_record? && safe_params.present?
        @product_attributes = safe_params[:product_attributes_array].inject(Hash.new) do |h, (values, attributes)|
          h[values[:key]] = values[:value]
          h
        end
      else
        @product_attributes ||= product.product_attributes.group_by(&:key).inject(Hash.new) do |h, (key, attributes)|
          h[key] = attributes.map(&:value).first
          h
        end
      end
    end

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, :file => []]
      params[:product].permit(:name, :sku, :permalink, :description, :weight, :price, :cost_price, :special_price, :tax_rate_id, :stock_control, :active, :featured, :attachments => [:default_image => file_params, :data_sheet => file_params, :extra => file_params], :product_attributes_array => [:key, :value], :product_category_ids => []) if params[:product]
    end

  end
end
