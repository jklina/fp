set :application, "fixelpuckers"
set :repository,  "ssh://hg@bitbucket.org/jklina/fixelpuckers/"
set :user, "jklina"
#set :scm_username, "jklina"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
 set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :mercurial

role :app, "development.pixelfuckers.org"
role :web, "development.pixelfuckers.org"
role :db,  "development.pixelfuckers.org", :primary => true