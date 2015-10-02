require 'rails/generators'
module Shoppe
  class SetupGenerator < Rails::Generators::Base
    
    def create_route
      route 'mount Shoppe::Engine => "/shoppe"'
      route 'devise_for :customers, class_name: "Shoppe::Customer"'
    end

  end
end
