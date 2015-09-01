module Shoppe
  class ProductAttributesController < Shoppe::ApplicationController

    def autocomplete
      render :json => Shoppe::ProductAttribute.search(params[:q]).result.limit(15).uniq.pluck(:key, :value)
    end

  end
end
