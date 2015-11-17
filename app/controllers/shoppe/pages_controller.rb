module Shoppe
  class PagesController < Shoppe::ApplicationController

    before_filter { @active_nav = :pages }
    before_filter { params[:id] && @page = Shoppe::Page.find(params[:id]) }

    def index
      @pages = initialize_grid Shoppe::Page, order: 'priority', order_direction: 'desc'
    end

    def new
      @page = Shoppe::Page.new
    end

    def create
      @page = Shoppe::Page.new(safe_params)
      if @page.save
        redirect_to :pages, :flash => {:notice => t('shoppe.pages.create_notice')}
      else
        render :action => "new"
      end
    end

    def edit
    end

    def update
      if @page.update(safe_params)
        redirect_to [:edit, @page], :flash => {:notice => t('shoppe.pages.update_notice') }
      else
        render :action => "edit"
      end
    end

    def destroy
      @page.destroy
      redirect_to :pages, :flash => {:notice => t('shoppe.pages.destroy_notice')}
    end

    private

    def safe_params
      params[:page].permit(:title, :menu_title, :permalink, :content, :published, :show_menu, :priority)
    end

  end
end
