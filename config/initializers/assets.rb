%w( products ).each do |controller|
  Rails.application.config.assets.precompile += ["shoppe/#{controller}.js", "shoppe/#{controller}.css"]
end