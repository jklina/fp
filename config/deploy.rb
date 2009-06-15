default_run_options[:pty] = true
default_environment["PATH"] = "/home/jklina/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin"

set :webfaction_username, "jklina"
set :webfaction_db_type, "mysql"
set :webfaction_db, "jklina_pf"
set :webfaction_db_username, "jklina_pf"
set :webfaction_port, "2613"
set :database_yml_template, "database.example.yml"
 
set :application, "fixelpuckers"
set :deploy_to, "/home/#{webfaction_username}/webapps-releases/#{application}"
 
set :scm, :mercurial
set :repository,  "ssh://hg@bitbucket.org/jklina/fixelpuckers/"
 
set :user, "#{webfaction_username}"
set :use_sudo, false 
 
set :domain, "jklina.webfactional.com"
 
role :app, domain
role :web, domain
role :db,  domain, :primary => true
 
desc "Symlink public to what webfaction expects the webroot to be"
task :after_symlink, :roles => :web do
  run "ln -nfs #{release_path}/public /home/#{webfaction_username}/webapps/#{application}/"
end

task :after_update_code, :roles => :app do
  #Makes sure all the images for submissions, etc appear to be in the public folder. They're really symlinks to the Capistrano shared folder though ;)
  %w{featured_images sub_files sub_images user_images}.each do |share|
    run "rm -rf #{release_path}/public/#{share}"
    run "mkdir -p #{shared_path}/system/#{share}"
    run "ln -nfs #{shared_path}/system/#{share} #{release_path}/public/#{share}"
  end
end

 
namespace :deploy do
 
  # Taken from http://jonathan.tron.name/2006/07/15/capistrano-password-prompt-tips 
  # Thanks Jonathan! :)
  desc "Creates the database configuration on the fly"
  task :create_database_configuration, :roles => :app do
    require "yaml"
    set :production_db_password, proc { Capistrano::CLI.password_prompt("Remote production database password: ") }
 
    db_config = YAML::load_file("config/#{database_yml_template}")
    db_config.delete('test')
    db_config.delete('development')
 
    db_config['production']['adapter'] = "#{webfaction_db_type}"
    db_config['production']['database'] = "#{webfaction_db}"
    db_config['production']['username'] = "#{webfaction_db_username}"
    db_config['production']['password'] = production_db_password
    db_config['production']['host'] = "localhost"
 
    put YAML::dump(db_config), "#{release_path}/config/database.yml", :mode => 0664
  end
 
  after "deploy:update_code", "deploy:create_database_configuration"
 
  desc "Redefine deploy:start"
  task :start, :roles => :app do
    invoke_command "LD_LIBRARY_PATH=/home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/gems/rmagick-2.9.1/lib:/home/#{webfaction_username}/lib /home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/bin/mongrel_rails start -c #{deploy_to}/current -d -e production -P /home/#{webfaction_username}/webapps/#{application}/log/mongrel.pid -p #{webfaction_port}", :via => run_method
  end
 
  desc "Redefine deploy:restart"
  task :restart, :roles => :app do
    invoke_command "LD_LIBRARY_PATH=/home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/gems/rmagick-2.9.1/lib:/home/#{webfaction_username}/lib /home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/bin/mongrel_rails restart -c #{deploy_to}/current -P /home/#{webfaction_username}/webapps/#{application}/log/mongrel.pid", :via => run_method
  end
 
  desc "Redefine deploy:stop"
  task :stop, :roles => :app do
    invoke_command "LD_LIBRARY_PATH=/home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/gems/rmagick-2.9.1/lib:/home/#{webfaction_username}/lib /home/#{webfaction_username}/ruby1.8/lib/ruby/gems/1.8/bin/mongrel_rails stop -c #{deploy_to}/current -P /home/#{webfaction_username}/webapps/#{application}/log/mongrel.pid", :via => run_method
  end
end

###############################