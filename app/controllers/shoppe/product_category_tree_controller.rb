module Shoppe
  class ProductCategoryTreeController < ApplicationController

    before_filter { @product = Shoppe::Product.find params[:id] }

    def edit
      selected_categories = @product.product_categories.map(&:id)
      product_categories = Shoppe::ProductCategory.nested_set.select('id, name, parent_id').all
      @product_categories_json = product_categories
                                     .to_a
                                     .map { |item| {text: item.name, id: item.id, parent: item.parent.blank? ? '#' : item.parent.id, state: {:checked => selected_categories.include?(item.id), :opened => true}} }
                                     .to_json

      if request.xhr?
        render :action => 'edit', :layout => false
      end
    end

    def update
      @product.update_attribute(:product_category_ids, params[:categories].map { |category_id| category_id if Shoppe::ProductCategory.find(category_id).leaf? })
      if request.xhr?
        render :json => {:success => true}
      end
    end

  end
end
