module Shoppe
  class CustomersController < Shoppe::ApplicationController

    before_filter { @active_nav = :customers }
    before_filter { params[:id] && @customer = Shoppe::Customer.find(params[:id]) }

    def index
      @customers = initialize_grid Shoppe::Customer, order: 'id', order_direction: 'desc'
    end

    def new
      @customer = Shoppe::Customer.new
    end

    def show
      @addresses = @customer.addresses.ordered.load
      @orders = @customer.orders.ordered.load
    end

    def login
      sign_in(:customer, @customer)
      redirect_to '/'
    end

    def confirm
      if @customer.confirmed?
        redirect_to request.referer, :flash => {:notice => "Customer has already confirmed"}
        return
      end

      @customer.skip_confirmation!
      if @customer.save
        redirect_to request.referer, :flash => {:notice => "Customer has been confirmed"}
      else
        redirect_to request.referer, :flash => {:notice => "Customer confirmation error"}
      end
    end

    def create
      @customer = Shoppe::Customer.new(safe_params)
      if @customer.save
        redirect_to @customer, flash: { notice: t('shoppe.customers.created_successfully') }
      else
        render action: 'new'
      end
    end

    def update
      if safe_params[:password].blank?
        update_customer = @customer.update_without_password(safe_params)
      else
        update_customer = @customer.update(safe_params)
      end

      if update_customer
        redirect_to @customer, flash: { notice: t('shoppe.customers.updated_successfully') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @customer.destroy
      redirect_to customers_path, flash: { notice: t('shoppe.customers.deleted_successfully') }
    end

    def search
      index
      render action: 'index'
    end

    private

    def safe_params
      params[:customer].permit(:first_name, :last_name, :company, :email, :phone, :mobile, :password, :password_confirmation, :newsletter_subscribed)
    end
  end
end
