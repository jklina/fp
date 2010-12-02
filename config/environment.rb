# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Fixelpuckers::Application.initialize!

PAPERCLIP_ASSET_PATH = ":rails_root/public/assets/:class/:attachment/:id/:style/:basename.:extension"
PAPERCLIP_ASSET_URL  = "/assets/:class/:attachment/:id/:style/:basename.:extension"

# Lifted from http://github.com/thoughtbot/paperclip/issues/#issue/33
PAPERCLIP_IMAGE = %r{^(image|(x-)?application)/(x-png|pjpeg|jpeg|jpg|png|gif)$}
