Fixelpuckers::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  
PAPERCLIP_ASSET_PATH = ":rails_root/public/assets/:class/:attachment/:id/:style/:basename.:extension"
PAPERCLIP_ASSET_URL  = "/assets/:class/:attachment/:id/:style/:basename.:extension"

# Lifted from http://github.com/thoughtbot/paperclip/issues/#issue/33
PAPERCLIP_IMAGE = %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$}
end

