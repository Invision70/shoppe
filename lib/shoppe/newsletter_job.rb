module Shoppe
  class NewsletterJob < Struct.new(:subject, :message, :emails)

    @last_step = nil

    def perform
      emails.each_with_index do |e,i|
        next if @last_step && @last_step+1 > i
        NewsletterMailer.prepare_mail(e, subject, message).deliver if e.present?
        @last_step = i
      end
    end

    def before(job)
      @last_step = job.last_step
    end

    def error(job, exception)
      job.update_attributes(:last_step => @last_step) unless @last_step.nil?
    end

    def max_attempts
      0
    end
  end
end
