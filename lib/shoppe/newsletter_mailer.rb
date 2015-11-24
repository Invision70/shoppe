module Shoppe
  class NewsletterMailer < ActionMailer::Base
    default from: Shoppe.settings.email_from

    def prepare_mail(email, subject, message)
      @message = message.html_safe
      @subject = subject
      @recipient = email
      mail to: email, subject: subject do |format|
        format.html { render "shoppe/mailer/newsletter" }
      end
    end
  end
end
