#Create initial admin user. Probably want to replace this with a script that let's the user create their own admin. 

# Create a new user
@user = User.new

# Attributes for the user
@attrib = {
  :username       => "admin",
  :name       => "admin",
  :email       => "admin@example.com",
  :access_level       => 3,
  :password       => 'secret',
  :password_confirmation       => 'secret',
  :confirmed       => true,
}

# Use 'send' to call the attributes= method on the object
@user.send :attributes=, @attrib, false

# Save the object
@user.save
