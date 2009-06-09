# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_fp_session',
  :secret      => 'b34b2a8318d1846f3ef4d407c8c4476cdfc4a9a658662b8e17c4c6ccc7049ada7d7de89aab9a408632da44882a203ced03c77afba6b09045dc8521912dd49928'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
