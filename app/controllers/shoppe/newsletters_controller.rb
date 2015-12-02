module Shoppe
  class NewslettersController < Shoppe::ApplicationController

    before_filter { @active_nav = :newsletters }
    before_filter { params[:id] && @newsletter_job = Delayed::Job.with_deleted.find(params[:id]) }
    before_filter { @newsletters = Delayed::Job.with_deleted.order('id DESC') }
    before_filter { @newsletter_form = Shoppe::Newsletter::Form.new(safe_params || Hash.new) }

    def index
    end

    def restore
      @newsletter_job = Delayed::Job.with_deleted.find(params[:newsletter_id])
      @newsletter_job.update_attributes({
          :locked_at => nil,
          :locked_by => nil,
          :failed_at => nil,
          :attempts => 0,
          :last_error => nil,
      })
      redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.restored_successfully') }
    end

    def create
      @newsletter_form = Shoppe::Newsletter::Form.new(safe_params)
      if @newsletter_form.valid?
        if params[:preview]
          render_preview
        else
          form_emails = @newsletter_form.emails.split("\r\n")
          Delayed::Job.enqueue NewsletterJob.new(@newsletter_form.subject, @newsletter_form.message, form_emails.blank? ? Shoppe::Customer.subscribed.collect(&:email) : form_emails)
          redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.created_successfully') }
        end
      else
        render action: 'index'
      end
    end


    def edit
      payload = @newsletter_job.payload_object
      @newsletter_form = Shoppe::Newsletter::Form.new({:message => payload.message, :subject => payload.subject})
    end

    def update
      @newsletter_form = Shoppe::Newsletter::Form.new(safe_params)
      unless @newsletter_form.valid?
        return render action: 'edit'
      end

      if params[:preview]
        render_preview
      else
        @newsletter_job.payload_object.subject = safe_params[:subject]
        @newsletter_job.payload_object.message = safe_params[:message]
        @newsletter_job.payload_object=(@newsletter_job.payload_object)
        @newsletter_job.save
        redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.updated_successfully') }
      end
    end


    def destroy
      @newsletter_job.destroy!
      redirect_to newsletters_path, flash: { notice: t('shoppe.newsletters.deleted_successfully') }
    end

    private

      def render_preview
        @subject = @newsletter_form.subject
        @message = @newsletter_form.message.html_safe
        @preview = true
        render 'shoppe/mailer/newsletter', :layout => nil
      end

      def safe_params
        params[:shoppe_newsletter_form].permit(:subject, :message, :emails) if params[:shoppe_newsletter_form]
      end

  end
end
