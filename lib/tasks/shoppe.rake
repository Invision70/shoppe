namespace :shoppe do

  desc "Load seed data for the Shoppe"
  task :seed => :environment do
    require File.join(Shoppe.root, 'db', 'seeds')
  end

  desc "Update stock availability"
  task :update_stock_availability => :environment do
    total = Shoppe::Product.count
    inc = 0
    Shoppe::Product.all.each do |product|
      product.update_attribute(:stock_availability, product.in_stock?)
      inc+=1
      STDOUT.write("\r#{inc} of #{total}")
    end
  end

  desc "Update full sku"
  task :update_full_sku => :environment do
    total = Shoppe::Product.count
    inc = 0
    Shoppe::Product.all.each do |product|
      product.update_attribute(:full_sku, product.full_sku_tree)
      inc+=1
      STDOUT.write("\r#{inc} of #{total}")
    end
  end

  desc "Recreate all attachment versions"
  task :recreate_attachment_versions => :environment do
    total = Shoppe::Attachment.count
    inc = 0
    Shoppe::Attachment.find_each do |attach|
      begin
        attach.file.recreate_versions!
      rescue Exception=>e
        puts e
      end
      inc+=1
      STDOUT.write("\r#{inc} of #{total}")
    end
  end

  
  desc "Create a default admin user"
  task :create_default_user => :environment do
    Shoppe::User.create(:email_address => 'admin@example.com', :password => 'password', :password_confirmation => 'password', :first_name => 'Default', :last_name => 'Admin')
    puts
    puts "    New user has been created successfully."
    puts
    puts "    E-Mail Address..: admin@example.com"
    puts "    Password........: password"
    puts
  end
  
  desc "Reset sku tree"
  task :reset_sku_tree => :environment do
    products = Shoppe::Product.all
    products.each do |product|
      product.full_sku = product.full_sku_tree
      product.save
    end
  end

  desc "Import default set of countries"
  task :import_countries => :environment do
    Shoppe::CountryImporter.import
  end

  desc "Import default set of states"
  task :import_states => :environment do
    Shoppe::StateImporter.import
  end
  
  desc "Run the key setup tasks for a new application"
  task :setup => :environment do
    Rake::Task["shoppe:import_countries"].invoke    if Shoppe::Country.all.empty?
    Rake::Task["shoppe:create_default_user"].invoke if Shoppe::User.all.empty?
  end

  desc "Converts nifty-attachment attachments to Shoppe Attachments"
  task :attachments => :environment do
    require "nifty/attachments"

    attachments = Nifty::Attachments::Attachment.all

    attachments.each do |attachment|
      object = attachment.parent_type.constantize.find(attachment.parent_id)

      attach = object.attachments.build
      attach.role = attachment.role
      attach.file_name = attachment.file_name

      tempfile = Tempfile.new("attach-#{attachment.token}")
      tempfile.binmode
      tempfile.write(attachment.data)
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: attachment.file_name, type: attachment.file_type)

      attach.file = uploaded_file
      attach.save!
    end
  end
  
end