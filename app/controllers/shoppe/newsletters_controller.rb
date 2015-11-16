module Shoppe
  class NewslettersController < Shoppe::ApplicationController

    before_filter { @active_nav = :newsletters }
    before_filter { params[:id] && @newsletter_job = Delayed::Job.with_deleted.find(params[:id]) }
    before_filter { @newsletters = Delayed::Job.with_deleted.order('id DESC') }

    def index
      @newsletter_form = Shoppe::Newsletter::Form.new(safe_params || Hash.new)
    end

    def create
      @newsletter_form = Shoppe::Newsletter::Form.new(safe_params)
      if @newsletter_form.valid?
        if params[:preview]
          @subject = @newsletter_form.subject
          @message = @newsletter_form.message.html_safe
          @preview = true
          render 'shoppe/mailer/newsletter', :layout => nil
        else
          form_emails = @newsletter_form.emails.split("\r\n")
          Delayed::Job.enqueue NewsletterJob.new(@newsletter_form.subject, @newsletter_form.message, form_emails.blank? ? Shoppe::Customer.subscribed.collect(&:email) : form_emails)
          redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.created_successfully') }
        end
      else
        render action: 'index'
      end
    end

    def destroy
      @newsletter_job.destroy!
      redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.deleted_successfully') }
    end

    private

    def safe_params
      params[:shoppe_newsletter_form].permit(:subject, :message, :emails) if params[:shoppe_newsletter_form]
    end

  end
end
