%w( products newsletters pages product_categories).each do |controller|
  Rails.application.config.assets.precompile += ["shoppe/#{controller}.js", "shoppe/#{controller}.css"]
end
