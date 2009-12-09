#Create initial admin user. Probably want to replace this with a script that let's the user create their own admin. 

User.find_or_create_by_username(:username => 'admin', :name => 'admins', :email => 'jlfds@jklfds.com', :access_level => 3, :password => 'secret', :password_confirmation => 'secret', :confirmed => true)