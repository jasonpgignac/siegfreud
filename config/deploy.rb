set :application, "Siegfreud"
default_run_options[:pty] = true
set :repository,  "git@github.com:jasonpgignac/siegfreud.git"
set :scm, "git"
set :scm_passphrase, "lamia6713"
set :user, "ptadmin"
set :password, "sys051976"
set :runner, "ptadmin"

set :deploy_to, "/Volumes/Untitled/siegfreud0.2"

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