if File.exist?("#{Rails.root}/config/app_settings.yml")
  AUTH = YAML.load_file("#{Rails.root}/config/app_settings.yml")['auth']
else
  AUTH = YAML.load_file("#{Rails.root}/config/default_app_settings.yml")['auth']
  puts "App settings not found. Loading defaults..."
end

puts AUTH['superadmin-password']

