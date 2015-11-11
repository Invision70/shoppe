module Shoppe
  module Newsletter
    class Form
      include ActiveForm::Form
      properties :subject, :message, :emails
      validates_presence_of :subject, :message
      validates_length_of :message, :minimum => 10
    end
  end
end