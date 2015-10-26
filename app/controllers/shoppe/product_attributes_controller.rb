module Shoppe
  class ProductAttributesController < Shoppe::ApplicationController

    before_filter { @active_nav = :product_attributes }
    before_filter { @product_attribute = Shoppe::ProductAttribute.find_by_key(params[:id]) if params[:id] }

    def index
      @product_attributes = Shoppe::ProductAttribute.group(:key, :for_variant).select(:key, :for_variant).order(:key)
    end

    def new
      @product_attribute = Shoppe::ProductAttribute.new
    end

    def create
      @product_attribute = Shoppe::ProductAttribute.new
      product_attributes = safe_params[:product_attributes_array].reject {|item| item[:value].blank? }
      if product_attributes.blank?
        render :action => "new", :flash => {:notice => t('shoppe.product_attributes.empty_notice') }
      else
        product_attributes.each do |attribute_value|
          Shoppe::ProductAttribute.create(attribute_value.merge({key: safe_params[:product_attributes][:key], for_variant: safe_params[:product_attributes][:for_variant]}).permit(:key, :value, :searchable, :public, :for_variant))
        end
        redirect_to product_attributes_path, :flash => {:notice => t('shoppe.product_attributes.create_notice') }
      end
    end

    def edit
      @attributes = Shoppe::ProductAttribute.where(key: @product_attribute.key).order(:created_at).group_by(&:value)
    end

    def update
      safe_params[:product_attributes_array].reject {|item| item[:value].blank? }.each do |attribute_value|
        replace_value = attribute_value.delete(:replace_value)
        if attribute_value[:remove].present?
          Shoppe::ProductAttribute.where(key: @product_attribute.key, value: replace_value).delete_all
        elsif replace_value.present?
          Shoppe::ProductAttribute.where(key: @product_attribute.key, value: replace_value).update_all(attribute_value)
        else
          Shoppe::ProductAttribute.create(attribute_value.to_hash.merge({key: @product_attribute.key}) )
        end
      end

      Shoppe::ProductAttribute.where(key: @product_attribute.key).update_all(key: safe_params[:product_attributes][:key], for_variant: safe_params[:product_attributes][:for_variant])
      redirect_to edit_product_attribute_path(safe_params[:product_attributes][:key]), :flash => {:notice => t('shoppe.product_attributes.update_notice') }
    end

    def destroy
      Shoppe::ProductAttribute.where(key: @product_attribute.key).delete_all
      redirect_to product_attributes_path, :notice => t('shoppe.product_attributes.destroy_notice')
    end

    private

    def safe_params
      product_attributes_defaults = {"public" => false, "searchable" => false}
      params.permit(:product_attributes => [:key])
      params.permit(:product_attributes_array => [:value, :replace_value, :searchable, :public, :remove, :for_variant])
      params[:product_attributes_array].map {|item| item.replace(product_attributes_defaults.merge(item))}
      params
    end

  end
end
