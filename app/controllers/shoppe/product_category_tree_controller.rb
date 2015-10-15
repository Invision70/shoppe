module Shoppe
  class ProductCategoryTreeController < ApplicationController

    before_filter { @product = Shoppe::Product.find params[:id] if params[:id] }

    def new
      self.edit
    end

    def edit
      selected_categories =  params[:product][:product_category_ids] if params[:product]
      product_categories = Shoppe::ProductCategory.nested_set.select('id, name, parent_id').all
      @product_categories_json = product_categories
                                     .to_a
                                     .map { |item| {text: item.name, id: item.id, parent: item.parent.blank? ? '#' : item.parent.id, state: {:checked => selected_categories && selected_categories.include?(item.id.to_s), :opened => false}} }
                                     .to_json

      render :action => 'form', :layout => ! request.xhr?
    end

  end
end
