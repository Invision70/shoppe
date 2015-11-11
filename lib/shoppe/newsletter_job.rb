module Shoppe
  class NewsletterJob < Struct.new(:subject, :message, :emails)
    def perform
      emails.each { |e| NewsletterMailer.prepare_mail(e, subject, message).deliver }
    end
  end
end