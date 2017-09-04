module Shoppe
  class ProductAttachmentsController < Shoppe::ApplicationController

    before_filter { @product = Shoppe::Product.not_variants.find(params[:id]) if params[:id] && params[:id] != '-1' }

    def logged_in?
      true
    end

    def destroy
      @attachment = Shoppe::Attachment.find_by!(token: params[:token])
      if @attachment.destroy
        render json: {status: true}
      else
        render :nothing => true, :status => 400
      end
    end

    def update
      if params[:sortable].present?
        params[:sortable].each_with_index { |val,index| Shoppe::Attachment.update(val, {sort: index}) }
      elsif @product.blank? # new record
        product = Shoppe::Product.new
        product.update(safe_params)
        product.attachments.map(&:save)
      else
        @product.update(safe_params)
      end
      self.show
    end

    def show
      if @product.present?
        render json: @product.attachments
      else
        render json: Shoppe::Attachment.where(parent_id: nil).order(sort: :asc, id: :asc).all
      end
    end

    def safe_params
      file_params = [:file, :file => []]
      params[:product].permit(:attachments => [:default_image => file_params, :extra => file_params], :product_attributes_array => [:key, :value, :public, :searchable, :multiple], :product_category_ids => []) if params[:product]
    end

  end
end
