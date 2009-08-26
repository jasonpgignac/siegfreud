set :application, "Siegfreud"
default_run_options[:pty] = true
set :repository,  "git@github.com:jasonpgignac/siegfreud.git"
set :scm, "git"
set :scm_passphrase, "lamia6713"
set :user, "ptadmin"
set :password, "sys051976"
set :runner, "ptadmin"
# If you have previously been relying upon the code to start, stop 
# and restart your mongrel application, or if you rely on the database
# migration code, please uncomment the lines you require below

# If you are deploying a rails app you probably need these:

#load 'ext/rails-database-migrations.rb'
#load 'ext/rails-shared-directories.rb'

# There are also new utility libaries shipped with the core these 
# include the following, please see individual files for more
# documentation, or run `cap -vT` with the following lines commented
# out to see what they make available.

# load 'ext/spinner.rb'              # Designed for use with script/spin
#load 'ext/passenger-mod-rails.rb'  # Restart task for use with mod_rails
# load 'ext/web-disable-enable.rb'   # Gives you web:disable and web:enable

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/Volumes/Untitled/siegfreud0.2"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
# see a full list by running "gem contents capistrano | grep 'scm/'"

role :web, "ussatx-xsod-001"
role :db, "ussatx-xsod-001", :primary => true
role :app, "ussatx-xsod-001"

namespace :deploy do
desc "Reestablish symblinks, in order to keep Sphinx indexes"
task :after_symlink do
  run <<-CMD
    rm -fr #{release_path}/db/sphinx &&
    ln -nfs #{shared_path}/db/sphinx #{release_path}/db/sphinx
  CMD
end  

desc "Stop the sphinx server"
task :stop_sphinx , :roles => :app do
  
  run "cd #{current_path} && rake thinking_sphinx:configure RAILS_ENV=production && rake thinking_sphinx:stop RAILS_ENV=production"
end

desc "Start the sphinx server" 
task :start_sphinx, :roles => :app do
  run "cd #{current_path} && rake thinking_sphinx:configure RAILS_ENV=production && rake thinking_sphinx:start RAILS_ENV=production"
end

desc "Restart the sphinx server"
task :restart_sphinx, :roles => :app do
  stop_sphinx
  start_sphinx
end

task :start, :roles => :app do
  restart_sphinx
end
task :restart, :roles => :app do
  restart_sphinx
end

end