module Shoppe
  class Engine < ::Rails::Engine
    isolate_namespace Shoppe

    if Shoppe.respond_to?(:root)
      config.active_job.queue_adapter = :delayed_job
      config.autoload_paths << File.join(Shoppe.root, 'lib')
      config.assets.precompile += ['shoppe/sub.css', 'shoppe/printable.css']
    end

    if Rails.env.development?
      config.after_initialize do
        Bullet.enable = true
        Bullet.alert = false
        Bullet.bullet_logger = true
        Bullet.console = true
        Bullet.rails_logger = true
      end
    end

    # We don't want any automatic generators in the engine.
    config.generators do |g|
      g.orm             :active_record
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

    config.to_prepare do
      Dir.glob(Rails.root + "app/decorators/**/*_decorator*.rb").each do |c|
        require_dependency(c)
      end
    end

    initializer 'shoppe.initialize' do |app|
      # Add the default settingsemail_from
      Shoppe.add_settings_group :system_settings, [:store_name, :email_address, :email_from, :currency_unit, :tax_name, :demo_mode, :only_latin_address]

      # Add middleware
      app.config.middleware.use Shoppe::SettingsLoader

      # Load our migrations into the application's db/migrate path
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end

      # Load view helpers for the base application
      ActiveSupport.on_load(:action_view) do
        require 'shoppe/view_helpers'
        ActionView::Base.send :include, Shoppe::ViewHelpers
      end

      ActiveSupport.on_load(:active_record) do
        require 'shoppe/model_extension'
        ActiveRecord::Base.send :include, Shoppe::ModelExtension
      end

      # Load default navigation
      require 'shoppe/default_navigation'
    end

    generators do
      require 'shoppe/setup_generator'
    end

  end
end
