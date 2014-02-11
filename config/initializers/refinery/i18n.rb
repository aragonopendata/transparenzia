# encoding: utf-8

Refinery::I18n.configure do |config|
  config.default_locale = :es
  config.current_locale = :es
  config.default_frontend_locale = :en
  config.frontend_locales = [:es, :en]
  config.locales = {:es=>"Español", :en => "English"}
end
