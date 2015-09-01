module Shoppe
  class ProductAttributesController < Shoppe::ApplicationController

    def autocomplete
      @product_attributes = Shoppe::ProductAttribute.search(params).result.limit(15).uniq
      if params.has_key?(:value_cont)
        render :json => @product_attributes.pluck(:value)
      else
        render :json => @product_attributes.pluck(:key)
      end
    end

  end
end
