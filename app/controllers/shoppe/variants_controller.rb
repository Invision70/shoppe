module Shoppe
  class VariantsController < ApplicationController

    before_filter { @active_nav = :products }
    before_filter {
      @product = Shoppe::Product.find(params[:product_id])
      @variant = @product.variants.find(params[:id]) if params[:id]
      @root_variants = @product.variants.roots.except_descendants(@variant) if @product
    }
    before_filter { @attributes = Shoppe::ProductAttribute.where(for_variant: true).grouped_hash }
    before_filter { @parent_variants = Shoppe::Product }

    def index
      @variants = @product.variants.order(:lft)
    end

    def new
      @variant = @product.variants.build
      @variant.price = @product.price
      @variant.cost_price = @product.cost_price
      @variant.special_price = @product.special_price
      @variant.weight = @product.weight
      render :action => "form"
    end

    def create
      @variant = @product.variants.build(safe_params)
      if @variant.save
        redirect_to [@product, :variants], :notice =>  t('shoppe.variants.create_notice')
      else
        render :action => "form"
      end
    end

    def edit
      render :action => "form"
    end

    def update
      if @variant.update(safe_params)
        redirect_to edit_product_variant_path(@product, @variant), :notice => t('shoppe.variants.update_notice')
      else
        render :action => "form"
      end
    end

    def destroy
      @variant.destroy
      redirect_to [@product, :variants], :notice =>  t('shoppe.variants.destroy_notice')
    end

    private

    def safe_params
      params[:product].permit(:name, :variant_type, :variant_parent_id, :permalink, :sku, :default_image_file, :price, :cost_price, :special_price, :tax_rate_id, :weight, :stock_control, :active, :default)
    end

  end
end
