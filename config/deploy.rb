set :application, "siegfreud"

set :repository,	"svn+ssh://ussatx-xsod-001.peroot.com/Volumes/Untitled/svnrepo/siegfreud"
set :deploy_to,		"/Library/WebServer/siegfreud"
# set :deploy_via,	:export

role :app, "ussatx-xsod-001"
role :web, "ussatx-xsod-001"
role :db, "ussatx-xsod-001", :primary => true

set :mongrel_cmd,	"/usr/bin/mongrel_rails_persist"
set :mongrel_ports,	3000..3003

set :user,		"ptadmin"
set :group,		"admin"

namespace :deploy do

	desc "Start Mongrels processes and add them to launchd."
  task :start, :roles => :app do
    mongrel_ports.each do |port|
      sudo "#{mongrel_cmd} start -p #{port} -e production \
            --user #{user} --group #{group} -c #{current_path}"
    end
  end

  desc "Stop Mongrels processes and remove them from launchd."
  task :stop, :roles => :app do
    mongrel_ports.each do |port|
      sudo "#{mongrel_cmd} stop -p #{port}"
    end
  end

  desc "Restart Mongrel processes"
  task :restart, :roles => :app do
    stop
    start
  end
 
end

