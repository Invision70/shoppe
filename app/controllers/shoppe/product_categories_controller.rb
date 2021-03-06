module Shoppe
  class ProductCategoriesController < Shoppe::ApplicationController

    include TheSortableTreeController::Rebuild

    before_filter { @active_nav = :product_categories }
    before_filter { params[:id] && @product_category = Shoppe::ProductCategory.find(params[:id]) }

    def index
      @product_categories = Shoppe::ProductCategory.nested_set.select('id, name, parent_id').all
    end

    def show
      redirect_to edit_product_category_path @product_category
    end

    def new
      @product_category = Shoppe::ProductCategory.new
    end

    def create
      @product_category = Shoppe::ProductCategory.new(safe_params)
      if @product_category.save
        redirect_to :product_categories, :flash => { :notice => t('shoppe.product_category.create_notice') }
      else
        render :action => "new"
      end
    end

    def edit
    end

    def update
      if @product_category.update(safe_params)
        redirect_to [:edit, @product_category], :flash => { :notice => t('shoppe.product_category.update_notice') }
      else
        render :action => "edit"
      end
    end

    def destroy
      @product_category.destroy
      redirect_to :product_categories, :flash => { :notice => t('shoppe.product_category.destroy_notice') }
    end

    def sortable_model
      Shoppe::ProductCategory
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, :file => []]
      params[:product_category].permit(:name, :permalink, :description, :parent_id, :permalink_includes_ancestors, :attachments => [:image => file_params])
    end

  end
end
