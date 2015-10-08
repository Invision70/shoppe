module Shoppe
  class Settings
    
    def initialize(hash)
      @hash = hash
    end
    
    def outbound_email_address
      "#{store_name} <#{email_address}>"
    end
    
    def method_missing(key, _ = nil)
      key = key.to_s.gsub(/\?\z/, '')
      defaults = I18n.translate("shoppe.settings.defaults")
      if value = @hash[key.to_s]
        value
      elsif defaults.is_a?(Hash) && defaults.keys.include?(key.to_sym)
        defaults[key.to_sym]
      end
    end
    
    def [](value)
      @hash[value]
    end
    
  end
end
