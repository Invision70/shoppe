module Shoppe
  class PromoCodesController < Shoppe::ApplicationController

    before_filter { @active_nav = :promo_codes }
    before_filter { params[:id] && @promo_code = Shoppe::PromoCode.find(params[:id]) }

    def index
      @promo_codes = initialize_grid Shoppe::PromoCode, order: 'id'
    end

    def new
      @promo_code = Shoppe::PromoCode.new
    end

    def create
      @promo_code = Shoppe::PromoCode.new(safe_params)
      if @promo_code.save
        redirect_to :promo_codes, :flash => {:notice => t('shoppe.promo_codes.create_notice')}
      else
        render :action => "new"
      end
    end

    def edit
    end

    def update
      if @promo_code.update(safe_params)
        redirect_to [:edit, @promo_code], :flash => {:notice => t('shoppe.promo_codes.update_notice') }
      else
        render :action => "edit"
      end
    end

    def destroy
      @promo_code.destroy
      redirect_to :promo_codes, :flash => {:notice => t('shoppe.promo_codes.destroy_notice')}
    end

    private

    def safe_params
      params[:promo_code].permit(:code, :discount, :type, :description, :min_price, :max_price, :end_at, :active)
    end

  end
end
