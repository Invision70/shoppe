$:.push File.expand_path("../lib", __FILE__)

require "shoppe/version"

Gem::Specification.new do |s|
  s.name        = "shoppe"
  s.version     = Shoppe::VERSION
  s.authors     = ["Adam Cooke", "Dean Perry"]
  s.email       = ["adam@atechmedia.com", "dean@voupe.com"]
  s.homepage    = "http://tryshoppe.com"
  s.summary     = "Just an e-commerce platform."
  s.licenses    = ["MIT"]
  s.description = "A full Rails engine providing e-commerce functionality for any Rails 4 application."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0.0", "< 5.0"
  s.add_dependency "bcrypt", ">= 3.1.2", "< 3.2"
  s.add_dependency "ransack", ">= 1.2.0", "< 1.6.3"
  s.add_dependency "kaminari", ">= 0.14.1", "< 0.17"
  s.add_dependency "haml-rails", "~> 0.9"
  s.add_dependency "turbolinks"
  s.add_dependency "net-ssh"
  s.add_dependency "dynamic_form", "~> 1.1", ">= 1.1.4"
  s.add_dependency "jquery-rails", ">= 3", "< 4.1"
  s.add_dependency "roo", ">= 1.13.0", "< 1.14"
  s.add_dependency "awesome_nested_set", "~> 3.0.2"
  s.add_dependency "the_sortable_tree", "~> 2.5.0"
  s.add_dependency "globalize"
  s.add_dependency "wice_grid", "3.6.0.pre2"
  s.add_dependency "font-awesome-sass", "~> 4.4.0"
  s.add_dependency "devise", "~> 3.5"
  s.add_dependency "jstree-rails-4"
  s.add_dependency "delayed_job_active_record"
  s.add_dependency "acts_as_paranoid", "0.5.0.beta2"
  s.add_dependency "activeform-rails"

  s.add_dependency "nifty-key-value-store", ">= 1.0.1", "< 2.0.0"
  s.add_dependency "nifty-utils", ">= 1.0", "< 1.1"
  s.add_dependency "nifty-dialog", ">= 1.0.7", "< 1.1"
  s.add_dependency "carrierwave", "~> 0.10.0"
  s.add_dependency "fog", "~> 1.31.0"
  s.add_dependency "rmagick", "~> 2.15.4"

  s.add_development_dependency "coffee-rails", "~> 4"
  s.add_development_dependency "sass-rails", "~> 4.0"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "yard", "~> 0"
  s.add_development_dependency "yard-activerecord", "~> 0"
  s.add_development_dependency "markdown", "~> 1.0"
  s.add_development_dependency "factory_girl_rails", "~> 4.5"
  s.add_development_dependency "bullet", "~> 5.6"
end
